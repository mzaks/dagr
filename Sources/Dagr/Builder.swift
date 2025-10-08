//
//  Builder.swift
//
//
//  Created by Maxim Zaks on 05.07.22.
//  https://github.com/mzaks/dagr
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public enum BuilderError: Error {
    case couldNotStoreRoot
    case wentOverMaxSize
}

public protocol Builder {
    var cursor: UInt64 { get }
    func store(string: String) throws -> UInt64
    func store(data: Data) throws -> UInt64
    func store(inline: [UInt8]) throws -> UInt64
    func store(bools: [Bool]) throws -> UInt64
    func storeWithOptionals(bools: [Bool?]) throws -> UInt64
    func store<T: EnumNode>(enum: T) throws -> UInt64
    func store<T: EnumNode>(enums: [T]) throws -> UInt64
    func storeWithOptionals<T: EnumNode>(enums: [T?]) throws -> UInt64
    func store(oneBitArray: [UInt8]) throws -> UInt64
    func storeWithOptionals(oneBitArray: [UInt8?]) throws -> UInt64
    func store(twoBitArray: [UInt8]) throws -> UInt64
    func storeWithOptionals(twoBitArray: [UInt8?]) throws -> UInt64
    func store(fourBitArray: [UInt8]) throws -> UInt64
    func storeWithOptionals(fourBitArray: [UInt8?]) throws -> UInt64
    func store(structNode: Node) throws -> UInt64?
    func store(rawPointer: UnsafeRawPointer, size: Int) throws -> UInt64
    func store<T : Numeric>(number: T) throws -> UInt64
    func store<T : Numeric>(numbers: [T]) throws -> UInt64
    func storeAsLEB(value: UInt64) throws -> UInt64
    func storeBidirectionalPointer(value: UInt64) throws -> UInt64
    func reserveFieldPointer(for structNodeId: Node) throws -> UInt64
    func storeForwardPointer(value: UInt64?) throws -> UInt64?
    func store(vTable:[UInt64?]) throws -> UInt64
    func storeSparse(vTable:[UInt64?]) throws -> UInt64
    func storeWithOptionals<T : Numeric>(numbers: [T?]) throws -> UInt64
    func store(strings: [String?]) throws -> UInt64
    func store(datas: [Data?]) throws -> UInt64
    func store<T: Node>(structNodes: [T?]) throws -> UInt64
    func store(unionType: AppliedUnionType) throws -> UInt64
    func store<T: UnionNode>(unionTypes: [T]) throws -> UInt64
    func storeWithOptionals<T: UnionNode>(unionTypes: [T?]) throws -> UInt64
    func update(vTablePointer: UInt16, at position: UInt64)
}

public final class DataBuilder: Builder {

    private var capacity : UInt64
    private let maxSize : UInt64
    private let reserveFieldPointerSize: Int
    private var _data : UnsafeMutableRawPointer
    public var cursor: UInt64 {
        _cursor
    }
    private var _cursor: UInt64 = 0
    private var leftCursor : UInt64 {
        return capacity - cursor
    }

    struct VTableLookupPair: Hashable {
        let index: UInt16
        let offset: UInt16
    }

    private var stringLookup = [String: UInt64]()
    private var vTableLookup = [[UInt64]: UInt64]()
    private var sparseVTableLookup = [[VTableLookupPair]: UInt64]()
    private var structNodeLookup = [ObjectIdentifier: UInt64]()
    private var nodesInProgress = Set<ObjectIdentifier>()
    private var nodesForLateBinding = [ObjectIdentifier: [(UInt64, UInt64?)]]()

    public init(maxSize: UInt64 = UInt64(Int32.max)) {
        self.maxSize = maxSize

        let numberOfBits = 64 - maxSize.leadingZeroBitCount
        self.reserveFieldPointerSize = (numberOfBits / 7) + (numberOfBits % 7 == 0 ? 0 : 1)
        self.capacity = 1024
        _data = UnsafeMutableRawPointer.allocate(byteCount: Int(capacity), alignment: 1)
    }

    deinit {
        _data.deallocate()
    }

    public var makeData : Data {
        return Data(bytes:_data.advanced(by:Int(leftCursor)), count: Int(cursor))
    }

    public func store(string: String) throws -> UInt64 {
        if let result = stringLookup[string] {
            return result
        }
        var stored = false
        try string.utf8.withContiguousStorageIfAvailable { bufferPointer in
            _ = try store(rawPointer: bufferPointer.baseAddress!, size: bufferPointer.count)
            _ = try storeAsLEB(value: UInt64(bufferPointer.count))
            stored = true
        }
        if stored == false {
            for c in string.utf8.lazy.reversed() {
                _ = try store(number: c)
            }
            _ = try storeAsLEB(value: UInt64(string.utf8.count))
        }

        stringLookup[string] = cursor

        return cursor
    }

    public func store(data: Data) throws -> UInt64 {
        try data.withContiguousStorageIfAvailable { bufferPointer in
            guard let pointer = bufferPointer.baseAddress else { return }
            _ = try store(rawPointer: pointer, size: bufferPointer.count)
            _ = try storeAsLEB(value: UInt64(bufferPointer.count))
        }
        return cursor
    }

    public func store(unionType: AppliedUnionType) throws -> UInt64 {
        let typeId: UInt64
        switch unionType {
        case .value(let value, let id):
            _ = try storeAsLEB(value: value)
            typeId = id
        case .pointer(let pointer, let id):
            _ = try storeForwardPointer(value: pointer)
            typeId = id
        case .bidirPointer(let pointer, let id):
            _ = try storeBidirectionalPointer(value: pointer)
            typeId = id
        case .reservedPointer(let structNodeId, let id):
            _ = try reserveFieldPointer(structNodeId: structNodeId)
            typeId = id
        }
        return try storeAsLEB(value: typeId)
    }

    public func store<T: UnionNode>(unionTypes: [T]) throws -> UInt64 {
        var widthCode = 0
        let appliedValues = try unionTypes.reversed().map{ try $0.apply(builder: self) }
        let values: [(UInt64, ObjectIdentifier?)] = appliedValues.map {
            switch $0 {
            case .value(let value, _):
                widthCode = max(widthCode, offsetWidthCode(value: value))
                return (value, nil)
            case .pointer(let pointer, _):
                let value = cursor - pointer
                widthCode = max(widthCode, offsetWidthCode(value: value))
                return (value, nil)
            case .bidirPointer(let pointer, _):
                let value = (cursor - pointer) << 1
                widthCode = max(widthCode, offsetWidthCode(value: value))
                return (value, nil)
            case .reservedPointer(let structNodeId, _):
                widthCode = max(widthCode, offsetWidthCode(value: maxSize << 1))
                return (0, structNodeId)
            }
        }
        let arrayEndOffset = cursor
        if widthCode == 0 {
            for (value, structNodeId) in values {
                _ = try store(number: UInt8(value))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        } else if widthCode == 1 {
            for (value, structNodeId) in values {
                _ = try store(number: UInt16(value))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        } else if widthCode == 2 {
           for (value, structNodeId) in values {
               _ = try store(number: UInt32(value))
               if let structNodeId {
                   setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
               }
           }
        } else {
            for (value, structNodeId) in values {
                _ = try store(number: UInt64(value))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        }
        switch T.byteWidth {
        case .eighth:
            _ = try store(inline: unionTypes.map{ $0.typeId == 1}.bitSet)
        case .quarter:
            try storeNoSize(twoBitArray: unionTypes.map { UInt8($0.typeId) })
        case .half:
            try storeNoSize(fourBitArray: unionTypes.map { UInt8($0.typeId) })
        case .one:
            try storeNoSize(numbers: unionTypes.map { UInt8($0.typeId) })
        case .two:
            try storeNoSize(numbers: unionTypes.map { UInt16($0.typeId) })
        case .four:
            try storeNoSize(numbers: unionTypes.map { UInt32($0.typeId) })
        case .eight:
            try storeNoSize(numbers: unionTypes.map { $0.typeId })
        }
        return try storeAsLEB(value: UInt64(unionTypes.count << 2) | UInt64(widthCode))
    }

    public func storeWithOptionals<T: UnionNode>(unionTypes: [T?]) throws -> UInt64 {
        var widthCode = 0
        var mask = [Bool]()
        let appliedValues = try unionTypes.map {
            let result = try $0?.apply(builder: self)
            mask.append(result != nil)
            return result
        }
        let values: [(UInt64, ObjectIdentifier?)] = appliedValues.reversed().map {
            guard let appliedValue = $0 else {
                return (0, nil)
            }
            switch appliedValue {
            case .value(let value, _):
                widthCode = max(widthCode, offsetWidthCode(value: value))
                return (value, nil)
            case .pointer(let pointer, _):
                let value = cursor - pointer
                widthCode = max(widthCode, offsetWidthCode(value: value))
                return (value, nil)
            case .bidirPointer(let pointer, _):
                let value = (cursor - pointer) << 1
                widthCode = max(widthCode, offsetWidthCode(value: value))
                return (value, nil)
            case .reservedPointer(let structNodeId, _):
                widthCode = max(widthCode, offsetWidthCode(value: maxSize << 1))
                return (0, structNodeId)
            }
        }
        let arrayEndOffset = cursor
        if widthCode == 0 {
            for (value, structNodeId) in values {
                _ = try store(number: UInt8(value))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        } else if widthCode == 1 {
            for (value, structNodeId) in values {
                _ = try store(number: UInt16(value))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        } else if widthCode == 2 {
           for (value, structNodeId) in values {
               _ = try store(number: UInt32(value))
               if let structNodeId {
                   setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
               }
           }
        } else {
            for (value, structNodeId) in values {
                _ = try store(number: UInt64(value))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        }
        switch T.byteWidth {
        case .eighth:
            _ = try store(inline: unionTypes.map{ $0?.typeId == 1}.bitSet)
        case .quarter:
            try storeNoSize(twoBitArray: unionTypes.map { UInt8($0?.typeId ?? 0) })
        case .half:
            try storeNoSize(fourBitArray: unionTypes.map { UInt8($0?.typeId ?? 0) })
        case .one:
            try storeNoSize(numbers: unionTypes.map { UInt8($0?.typeId ?? 0) })
        case .two:
            try storeNoSize(numbers: unionTypes.map { UInt16($0?.typeId ?? 0) })
        case .four:
            try storeNoSize(numbers: unionTypes.map { UInt32($0?.typeId ?? 0) })
        case .eight:
            try storeNoSize(numbers: unionTypes.map { $0?.typeId ?? 0 })
        }
        _ = try store(inline: mask.bitSet)
        return try storeAsLEB(value: UInt64(unionTypes.count << 2) | UInt64(widthCode))
    }

    public func store(bools: [Bool]) throws -> UInt64 {
        _ = try store(inline: bools.bitSet)
        return try storeAsLEB(value: UInt64(bools.count))
    }

    public func storeWithOptionals(bools: [Bool?]) throws -> UInt64 {
        let defaulted = bools.map { $0 ?? false }
        _ = try store(inline: defaulted.bitSet)
        _ = try store(inline: bools.map { $0 != nil }.bitSet)
        return try storeAsLEB(value: UInt64(bools.count))
    }

    public func store<T : Numeric>(numbers: [T]) throws -> UInt64 {
        for number in numbers.reversed() {
            _ = try store(number: number)
        }
        return try storeAsLEB(value: UInt64(numbers.count))
    }

    public func storeNoSize<T : Numeric>(numbers: [T]) throws {
        for number in numbers.reversed() {
            _ = try store(number: number)
        }
    }

    public func storeWithOptionals<T : Numeric>(numbers: [T?]) throws -> UInt64 {
        for number in numbers.reversed() {
            _ = try store(number: number ?? 0)
        }
        _ = try store(inline: numbers.map { $0 != nil }.bitSet)
        return try storeAsLEB(value: UInt64(numbers.count))
    }

    public func store(strings: [String?]) throws -> UInt64 {
        let offsets = try strings.reversed().map { $0 == nil ? nil : try store(string: $0!) }
        var widthCode = 0
        let relativeOffsets: [UInt64] = offsets.map {
            guard let offset = $0 else { return  0 }
            let relOffset = cursor - offset + 1 // because 0 identifies `nil`
            widthCode = max(widthCode, offsetWidthCode(value: relOffset))
            return relOffset
        }
        if widthCode == 0 {
            for relativeOffset in relativeOffsets {
                _ = try store(number: UInt8(relativeOffset))
            }
        } else if widthCode == 1 {
            for relativeOffset in relativeOffsets {
                _ = try store(number: UInt16(relativeOffset))
            }
        } else if widthCode == 2 {
            for relativeOffset in relativeOffsets {
                _ = try store(number: UInt32(relativeOffset))
            }
        } else if widthCode == 3 {
            for relativeOffset in relativeOffsets {
                _ = try store(number: UInt64(relativeOffset))
            }
        }
        return try storeAsLEB(value: UInt64(strings.count << 2) | UInt64(widthCode))
    }

    public func store(datas: [Data?]) throws -> UInt64 {
        let offsets = try datas.reversed().map { $0 == nil ? nil : try store(data: $0!) }
        var widthCode = 0
        let relativeOffsets: [UInt64] = offsets.map {
            guard let offset = $0 else { return  0 }
            let relOffset = cursor - offset + 1 // because 0 identifies `nil`
            widthCode = max(widthCode, offsetWidthCode(value: relOffset))
            return relOffset
        }
        if widthCode == 0 {
            for relativeOffset in relativeOffsets {
                _ = try store(number: UInt8(relativeOffset))
            }
        } else if widthCode == 1 {
            for relativeOffset in relativeOffsets {
                _ = try store(number: UInt16(relativeOffset))
            }
        } else if widthCode == 2 {
            for relativeOffset in relativeOffsets {
                _ = try store(number: UInt32(relativeOffset))
            }
        } else if widthCode == 3 {
            for relativeOffset in relativeOffsets {
                _ = try store(number: UInt64(relativeOffset))
            }
        }
        return try storeAsLEB(value: UInt64(datas.count << 2) | UInt64(widthCode))
    }

    public func store<T: Node>(structNodes: [T?]) throws -> UInt64 {
        var widthCode = 0
        let offsets: [(UInt64?, ObjectIdentifier?)] = try structNodes.reversed().map {
            guard let structNode = $0 else {
                return (nil, nil)
            }
            let offset = try store(structNode: structNode)
            if offset == nil {
                widthCode = offsetWidthCode(value: maxSize << 1)
                return (nil, ObjectIdentifier(structNode))
            }
            return (offset, nil)
        }
        let relativeOffsets: [(UInt64, ObjectIdentifier?)] = offsets.map {
            guard let offset = $0.0 else {
                return (0, $0.1)
            }
            let relOffset = (cursor - offset + 1) << 1 // because 0 identifies `nil`
            widthCode = max(widthCode, offsetWidthCode(value: relOffset))
            return (relOffset, nil)
        }
        let arrayEndOffset = cursor
        if widthCode == 0 {
            for (relativeOffset, structNodeId) in relativeOffsets {
                _ = try store(number: UInt8(relativeOffset))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        } else if widthCode == 1 {
            for (relativeOffset, structNodeId) in relativeOffsets {
                _ = try store(number: UInt16(relativeOffset))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        } else if widthCode == 2 {
            for (relativeOffset, structNodeId) in relativeOffsets {
                _ = try store(number: UInt32(relativeOffset))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        } else if widthCode == 3 {
            for (relativeOffset, structNodeId) in relativeOffsets {
                _ = try store(number: UInt64(relativeOffset))
                if let structNodeId {
                    setNodeForLateBinding(structNodeId: structNodeId, offset: arrayEndOffset)
                }
            }
        }
        return try storeAsLEB(value: UInt64(structNodes.count << 2) | UInt64(widthCode))
    }

    private func offsetWidthCode(value: UInt64) -> Int {
        if value <= UInt8.max {
            return 0
        }
        if value <= UInt16.max {
            return 1
        }
        if value <= UInt32.max {
            return 2
        }
        return 3
    }

    public func store(vTable: [UInt64?]) throws -> UInt64 {
        var normalisedTable = [UInt64](repeating: 0, count: vTable.count)
        var is16Bit = false
        for index in 0..<vTable.count {
            if let valueCursor = vTable[index] {
                normalisedTable[index] = cursor - valueCursor + 1
            } else {
                normalisedTable[index] = 0
            }
            is16Bit = is16Bit || normalisedTable[index] > UInt8.max
        }

        if let pointer = vTableLookup[normalisedTable] {
            return try storeAsLEB(value: (cursor - pointer) << 1)
        }

        let vTableCursor: UInt64
        if is16Bit {
            let count = (vTable.count << 1) | 1
            let numberOfBits = 64 - count.leadingZeroBitCount
            let vTableSize = (numberOfBits / 7) + (numberOfBits % 7 == 0 ? 0 : 1) + vTable.count * 2

            vTableCursor = try storeAsLEB(value: UInt64(vTableSize).toNegativZigZag) // store negativ offset

            for v in normalisedTable.reversed() {
                _ = try store(number: UInt16(v))
            }
            vTableLookup[normalisedTable] = try storeAsLEB(value: UInt64(count))
        } else {
            let count = (vTable.count << 1)
            let numberOfBits = 64 - count.leadingZeroBitCount
            let vTableSize = (numberOfBits / 7) + (numberOfBits % 7 == 0 ? 0 : 1) + vTable.count

            vTableCursor = try storeAsLEB(value: vTableSize == 0 ? 0 : UInt64(vTableSize).toNegativZigZag) // store negativ offset
            for v in normalisedTable.reversed() {
                _ = try store(number: UInt8(v))
            }
            vTableLookup[normalisedTable] = try storeAsLEB(value: UInt64(count))
        }
        return vTableCursor
    }

    public func storeSparse(vTable: [UInt64?]) throws -> UInt64 {
        var pairs = [VTableLookupPair]()
        var is16Bit = false
        for (index, value) in vTable.enumerated() {
            guard let value = value else { continue }
            let offset = UInt16(cursor - value)
            pairs.append(VTableLookupPair(index: UInt16(index), offset: offset))
            is16Bit = is16Bit || index > UInt8.max || offset > UInt8.max
        }

        if let pointer = sparseVTableLookup[pairs] {
            return try storeAsLEB(value: (cursor - pointer).toZigZag)
        }

        let vTableCursor: UInt64
        if is16Bit {
            let count = (pairs.count << 1) | 1
            let numberOfBits = 64 - count.leadingZeroBitCount
            let vTableSize = (numberOfBits / 7) + (numberOfBits % 7 == 0 ? 0 : 1) + pairs.count * 4

            vTableCursor = try storeAsLEB(value: UInt64(vTableSize).toNegativZigZag) // store negativ offset

            for pair in pairs.reversed() {
                _ = try store(number: pair.offset)
                _ = try store(number: pair.index)
            }
            sparseVTableLookup[pairs] = try storeAsLEB(value: UInt64(count))
        } else {
            let count = (pairs.count << 1)
            let numberOfBits = 64 - count.leadingZeroBitCount
            let vTableSize = (numberOfBits / 7) + (numberOfBits % 7 == 0 ? 0 : 1) + pairs.count * 2

            vTableCursor = try storeAsLEB(value: vTableSize == 0 ? 0 : UInt64(vTableSize).toNegativZigZag) // store negativ offset
            for pair in pairs.reversed() {
                _ = try store(number: UInt8(pair.offset))
                _ = try store(number: UInt8(pair.index))
            }
            sparseVTableLookup[pairs] = try storeAsLEB(value: UInt64(count))
        }
        return vTableCursor
    }

    public func store(inline: [UInt8]) throws -> UInt64 {
        try inline.withContiguousStorageIfAvailable { bufferPointer in
            guard let pointer = bufferPointer.baseAddress else { return }
            _ = try store(rawPointer: pointer, size: bufferPointer.count)
        }
        return cursor
    }

    public func store<T: EnumNode>(enum: T) throws -> UInt64 {
        switch T.byteWidth {
        case .eighth, .quarter, .half, .one:
            return try store(number: UInt8(`enum`.value))
        case .two:
            return try store(number: UInt16(`enum`.value))
        case .four:
            return try store(number: UInt32(`enum`.value))
        case .eight:
            return try store(number: UInt64(`enum`.value))
        }
    }

    public func store<T: EnumNode>(enums: [T]) throws -> UInt64 {
        switch T.byteWidth {
        case .eighth:
            return try store(oneBitArray: enums.map{ UInt8($0.value) })
        case .quarter:
            return try store(twoBitArray: enums.map{ UInt8($0.value) })
        case .half:
            return try store(fourBitArray: enums.map{ UInt8($0.value) })
        case .one:
            return try store(numbers: enums.map{ UInt8($0.value) })
        case .two:
            return try store(numbers: enums.map{ UInt16($0.value) })
        case .four:
            return try store(numbers: enums.map{ UInt32($0.value) })
        case .eight:
            return try store(numbers: enums.map{ UInt64($0.value) })
        }
    }

    public func storeWithOptionals<T: EnumNode>(enums: [T?]) throws -> UInt64 {
        switch T.byteWidth {
        case .eighth:
            return try storeWithOptionals(oneBitArray: enums.map{ $0 == nil ? nil : UInt8($0!.value) })
        case .quarter:
            return try storeWithOptionals(twoBitArray: enums.map{ $0 == nil ? nil : UInt8($0!.value) })
        case .half:
            return try storeWithOptionals(fourBitArray: enums.map{ $0 == nil ? nil : UInt8($0!.value) })
        case .one:
            return try storeWithOptionals(numbers: enums.map{ $0 == nil ? nil : UInt8($0!.value) })
        case .two:
            return try storeWithOptionals(numbers: enums.map{ $0 == nil ? nil : UInt16($0!.value) })
        case .four:
            return try storeWithOptionals(numbers: enums.map{ $0 == nil ? nil : UInt32($0!.value) })
        case .eight:
            return try storeWithOptionals(numbers: enums.map{ $0 == nil ? nil : UInt64($0!.value) })
        }
    }

    public func store(twoBitArray: [UInt8]) throws -> UInt64 {
        try storeNoSize(twoBitArray: twoBitArray)
        return try storeAsLEB(value: UInt64(twoBitArray.count))
    }

    private func storeNoSize(twoBitArray: [UInt8]) throws {
        var compacted = [UInt8]()
        for (index, v) in twoBitArray.enumerated() {
            if index & 3 == 0 {
                compacted.append(v & 3)
            } else {
                compacted[index >> 2] |= (v & 3) << ((index & 3) << 1)
            }
        }
        _ = try store(inline: compacted)
    }

    public func storeWithOptionals(twoBitArray: [UInt8?]) throws -> UInt64 {
        var valuesMask = [Bool]()
        var compacted = [UInt8]()
        for (index, v) in twoBitArray.enumerated() {
            if let v {
                valuesMask.append(true)
                if index & 3 == 0 {
                    compacted.append(v & 3)
                } else {
                    compacted[index >> 2] |= (v & 3) << ((index & 3) << 1)
                }
            } else {
                valuesMask.append(false)
                if index & 3 == 0 {
                    compacted.append(0)
                }
            }
        }
        _ = try store(inline: compacted)
        return try store(bools: valuesMask)
    }

    public func store(fourBitArray: [UInt8]) throws -> UInt64 {
        try storeNoSize(fourBitArray: fourBitArray)
        return try storeAsLEB(value: UInt64(fourBitArray.count))
    }

    private func storeNoSize(fourBitArray: [UInt8]) throws {
        var compacted = [UInt8]()
        for (index, v) in fourBitArray.enumerated() {
            if index & 1 == 0 {
                compacted.append(v & 15)
            } else {
                compacted[index >> 1] |= (v & 15) << ((index & 1) << 2)
            }
        }
        _ = try store(inline: compacted)
    }

    public func storeWithOptionals(fourBitArray: [UInt8?]) throws -> UInt64 {
        var valuesMask = [Bool]()
        var compacted = [UInt8]()
        for (index, v) in fourBitArray.enumerated() {
            if let v {
                valuesMask.append(true)
                if index & 1 == 0 {
                    compacted.append(v & 15)
                } else {
                    compacted[index >> 1] |= (v & 15) << ((index & 1) << 2)
                }
            } else {
                valuesMask.append(false)
                if index & 1 == 0 {
                    compacted.append(0)
                }
            }
        }
        _ = try store(inline: compacted)
        return try store(bools: valuesMask)
    }

    public func store(structNode: Node) throws -> UInt64? {
        let structNodeId = ObjectIdentifier(structNode)
        guard !nodesInProgress.contains(structNodeId) else { return nil }
        if let offset = structNodeLookup[structNodeId] {
            return offset
        }
        nodesInProgress.insert(structNodeId)
        let offset = try structNode.apply(builder: self)
        nodesInProgress.remove(structNodeId)
        if let bindings = nodesForLateBinding[structNodeId] {
            for (position, arrayEndOffset) in bindings {
                if let arrayEndOffset {
                    let signEncodedOffset = (Int64(arrayEndOffset) - Int64(offset)).toZigZag
                    if signEncodedOffset <= UInt8.max {
                        store(number: UInt8(signEncodedOffset), at: position)
                    } else if signEncodedOffset <= UInt16.max {
                        store(number: UInt16(signEncodedOffset), at: position)
                    } else if signEncodedOffset <= UInt32.max {
                        store(number: UInt32(signEncodedOffset), at: position)
                    } else {
                        store(number: UInt64(signEncodedOffset), at: position)
                    }
                } else {
                    _ = try storeAsLEB(value: (Int64(position) - Int64(offset)).toZigZag, at: position)
                }
                nodesForLateBinding.removeValue(forKey: structNodeId)
            }

        }
        structNodeLookup[structNodeId] = offset
        return offset
    }

    public func store<T : Numeric>(number : T) throws -> UInt64 {
        var number = number
        return try withUnsafeBytes(of: &number) { buffer in
            try store(rawPointer: buffer.baseAddress!, size: buffer.count)
        }
    }

    private func store<T : Numeric>(number : T, at positionFromEnd: UInt64) {
        var number = number
        let offset = capacity - positionFromEnd
        withUnsafeBytes(of: &number) { buffer in
            _data.advanced(by: Int(offset)).copyMemory(from: buffer.baseAddress!, byteCount: buffer.count)
        }
    }

    public func store(rawPointer: UnsafeRawPointer, size: Int) throws -> UInt64 {
        try reserveAdditionalCapacity(size: size)
        _data.advanced(by: Int(leftCursor) - size).copyMemory(from: rawPointer, byteCount: size)
        _cursor += UInt64(Int64(size))
        return cursor
    }

    public func reserveFieldPointer(for structNode: Node) throws -> UInt64 {
        _ = try store(inline: [UInt8](repeating: 0, count: reserveFieldPointerSize))
        setNodeForLateBinding(structNodeId: ObjectIdentifier(structNode), offset: nil)
        return cursor
    }

    public func reserveFieldPointer(structNodeId: ObjectIdentifier) throws -> UInt64 {
        _ = try store(inline: [UInt8](repeating: 0, count: reserveFieldPointerSize))
        setNodeForLateBinding(structNodeId: structNodeId, offset: nil)
        return cursor
    }

    public func storeAsLEB(value: UInt64) throws -> UInt64 {
        try storeAsLEB(value: value, at: nil)
    }

    private func storeAsLEB(value: UInt64, at positionFromEnd: UInt64?) throws -> UInt64 {
        guard value > 0 else {
            if let positionFromEnd {
                store(number: UInt8(0), at: positionFromEnd)
                return cursor
            }
            return try store(number: UInt8(0))
        }
        let numberOfBits = 64 - value.leadingZeroBitCount
        let numberOfBytes = (numberOfBits / 7) + (numberOfBits % 7 == 0 ? 0 : 1)

        try reserveAdditionalCapacity(size: numberOfBytes)

        var index = 0
        var rest = value

        let position: Int
        if let positionFromEnd = positionFromEnd {
            position = Int(capacity - positionFromEnd)
        } else {
            position = Int(leftCursor) - numberOfBytes
        }
        while rest > 0 {
            let sevenBits = UInt8(rest & 0b0111_1111) | 0b1000_0000
            _data.storeBytes(of: sevenBits, toByteOffset: position + index, as: UInt8.self)
            index += 1
            rest >>= 7
        }
        // this is to avoid branching in the while loop
        _data.storeBytes(
            of: _data.load(fromByteOffset: position + numberOfBytes - 1, as: UInt8.self) & 0b0111_1111,
            toByteOffset: position + numberOfBytes - 1,
            as: UInt8.self
        )
        if positionFromEnd == nil {
            _cursor += UInt64(numberOfBytes)
        }
        return cursor
    }

    public func storeForwardPointer(value: UInt64?) throws -> UInt64? {
        if let value {
            return try storeAsLEB(value: cursor - value)
        }
        return nil
    }

    public func storeBidirectionalPointer(value: UInt64) throws -> UInt64 {
        return try storeAsLEB(value: (cursor - value).toZigZag)
    }

    public func update(vTablePointer: UInt16, at position: UInt64) {
        var value = vTablePointer
        withUnsafeBytes(of: &value) { buffer in
            _data.advanced(by: Int(capacity - position)).copyMemory(from: buffer.baseAddress!, byteCount: buffer.count)
        }
    }

    public func store(oneBitArray: [UInt8]) throws -> UInt64 {
        // TODO: optimise
        let bools = oneBitArray.map { $0 == 0 ? false : true }
        return try store(bools: bools)
    }

    public func storeWithOptionals(oneBitArray: [UInt8?]) throws -> UInt64 {
        // TODO: optimise
        let bools = oneBitArray.map { $0 == nil ? nil : $0! == 0 ? false : true }
        return try storeWithOptionals(bools: bools)
    }

    private func reserveAdditionalCapacity(size : Int) throws {
        guard leftCursor <= size else {
            return
        }
        let _leftCursor = leftCursor
        while leftCursor <= size {
            capacity = capacity << 1
        }

        guard capacity <= maxSize else {
            throw BuilderError.wentOverMaxSize
        }

        let newData = UnsafeMutableRawPointer.allocate(byteCount: Int(capacity), alignment: 1)
        newData.advanced(by:Int(leftCursor)).copyMemory(from: _data.advanced(by: Int(_leftCursor)), byteCount: Int(cursor))
        _data.deallocate()
        _data = newData
    }

    private func setNodeForLateBinding(structNodeId: ObjectIdentifier, offset: UInt64?) {
        if let bindings = nodesForLateBinding[structNodeId] {
            nodesForLateBinding[structNodeId] = bindings + [(cursor, offset)]
        } else {
            nodesForLateBinding[structNodeId] = [(cursor, offset)]
        }

    }
}
