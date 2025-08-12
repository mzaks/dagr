//
//  Reader.swift
//
//
//  Created by Maxim Zaks on 05.10.22.
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

enum ReaderError: Error {
    case badOffset(Int64)
    case couldNotReadNumericType(any Numeric.Type)
    case unfinishedLEB
    case unfittingString
    case unfittingNumericType
    case unfittingData
    case unfittingBoolArray
    case unfittingEnumValue
    case unfittingUnionType
    case badVTableCount(Int)
    case badStructOffset
}

public protocol Reader {
    var cursor: UInt64 { get }
    func seek(to value: UInt64) throws
    func seek(by value: Int64) throws
    func readNumeric<T: Numeric>() throws -> T
    func readAndSeekNumeric<T: Numeric>() throws -> T
    func readBool() throws -> Bool
    func readAndSeekBool() throws -> Bool
    func readLEB() throws -> UInt64
    func readAndSeekLEB() throws -> UInt64
    func readAndSeekSignedLEB() throws -> Int64
    func readSting() throws -> String
    func readAndSeekSting() throws -> String
    func readData() throws -> Data
    func readAndSeekData() throws -> Data
    func readBoolArray() throws -> [Bool]
    func readAndSeekBoolArray() throws -> [Bool]
    func readAndSeekBoolArrayWithLength(length: UInt64) throws -> [Bool]
    func readAndSeekVTable() throws -> [Int64?]
    func readAndSeekSparseVTable() throws -> [UInt16: Int64]
    func readAndSeekArrayPointers(encodedLength: UInt64) throws -> [Int64]
    func readAndSeekFourBitArray() throws -> [UInt8]
    func readAndSeekFourBitArrayWithLength(length: UInt64) throws -> [UInt8]
    func readAndSeekTwoBitArray() throws -> [UInt8]
    func readAndSeekSingleBitArray() throws -> [UInt8]
    func readAndSeekSingleBitArrayWithLength(length: UInt64) throws -> [UInt8]
    func readAndSeekNumericArray<T: Numeric>() throws -> [T]
    func readAndSeekNumericArrayWithLength<T: Numeric>(length: UInt64) throws -> [T]
    func readAndSeekTwoBitArrayWithLength(length: UInt64) throws -> [UInt8]
    func readAndSeekUIntArray(encodedLength: UInt64) throws -> [UInt64]
    func getStructNode<T: Node>(from offset: UInt64) throws -> (T, Bool)
    func readAndSeekNumericArrayWithOptionals<T: Numeric>() throws -> [T?]
    func readAndSeekBoolArrayWithOptionals() throws -> [Bool?]
    func readAndSeekStringArray() throws -> [String]
    func readAndSeekStringArrayWithOptionals() throws -> [String?]
    func readAndSeekDataArray() throws -> [Data]
    func readAndSeekDataArrayWithOptionals() throws -> [Data?]
    func readAndSeekStructArray<T: Node>() throws -> [T]
    func readAndSeekStructArrayWithOptionals<T: Node>() throws -> [T?]
    func readAndSeekEnum<T: EnumNode>() throws -> T
    func readAndSeekEnumArray<T: EnumNode>() throws -> [T]
    func readAndSeekEnumArrayWithOptionals<T: EnumNode>() throws -> [T?]
    func readAndSeekUnionTypeArray<T: UnionNode>() throws -> [T]
    func readAndSeekUnionTypeArrayWithOptionals<T: UnionNode>() throws -> [T?]
}


public class DataReader: Reader {

    private let data: Data
    private var structCache: [UInt64: Node] = [:]
    public var cursor: UInt64

    public init(data: Data) {
        self.data = data
        cursor = 0
    }

    public func seek(to value: UInt64) throws {
        guard value <= data.count else {
            throw ReaderError.badOffset(Int64(value))
        }
        cursor = value
    }

    public func seek(by value: Int64) throws {
        let newCursor = Int64(cursor) + value
        guard newCursor >= 0 && newCursor <= data.count else {
            throw ReaderError.badOffset(newCursor)
        }
        cursor = UInt64(newCursor)
    }

    public func readNumeric<T>() throws -> T where T : Numeric {
        let upperBound = Int(cursor) + MemoryLayout<T>.size
        guard upperBound <= data.count else {
            throw ReaderError.badOffset(Int64(upperBound))
        }
        let buffer = UnsafeMutableBufferPointer<T>.allocate(capacity: 1)
        let range = Int(cursor)..<upperBound

        data.copyBytes(to: buffer, from: range)
        guard let value = buffer.first else {
            throw ReaderError.couldNotReadNumericType(T.self)
        }
        return value
    }

    public func readBool() throws -> Bool {
        let value: UInt8 = try readNumeric()
        return value == 1
    }

    public func readAndSeekBool() throws -> Bool {
        let value = try readBool()
        try seek(by: Int64(MemoryLayout<Bool>.size))
        return value
    }

    public func readAndSeekNumeric<T>() throws -> T where T : Numeric {
        let value: T = try readNumeric()
        try seek(by: Int64(MemoryLayout<T>.size))
        return value
    }

    public func readLEB() throws -> UInt64 {
        let currentCursor = cursor
        let value = try readAndSeekLEB()
        cursor = currentCursor
        return value
    }

    public func readAndSeekLEB() throws -> UInt64 {
        var result: UInt64 = 0
        var index: UInt64 = 0
        while Int(index + cursor) < data.count {
            let value = data[Int(index + cursor)]
            result += UInt64(value & 127) << (7 * index)
            if value >> 7 == 0 {
                try seek(by: Int64(index + 1))
                return result
            }
            index += 1
        }
        throw ReaderError.unfinishedLEB
    }

    public func readAndSeekSignedLEB() throws -> Int64 {
        let leb = try readAndSeekLEB()
        return leb.fromZigZag
    }

    public func readSting() throws -> String {
        let currentCursor = cursor
        let value = try readAndSeekSting()
        cursor = currentCursor
        return value
    }

    public func readAndSeekSting() throws -> String {
        let length = try readAndSeekLEB()
        guard cursor + length <= data.count else {
            throw ReaderError.unfittingString
        }
        return String(decoding:data[cursor..<(cursor + length)], as: UTF8.self)
    }

    public func readData() throws -> Data {
        let currentCursor = cursor
        let value = try readAndSeekData()
        cursor = currentCursor
        return value
    }

    public func readAndSeekData() throws -> Data {
        let length = try readAndSeekLEB()
        guard cursor + length <= data.count else {
            throw ReaderError.unfittingData
        }
        return data[cursor..<(cursor + length)]
    }

    public func readBoolArray() throws -> [Bool] {
        let currentCursor = cursor
        let value = try readAndSeekBoolArray()
        cursor = currentCursor
        return value
    }

    public func readAndSeekBoolArray() throws -> [Bool] {
        let length = try readAndSeekLEB()
        return try readAndSeekBoolArrayWithLength(length: length)
    }

    public func readAndSeekBoolArrayWithLength(length: UInt64) throws -> [Bool] {
        guard cursor < data.count else {
            throw ReaderError.unfittingBoolArray
        }
        var result = [Bool]()
        var value = data[Data.Index(cursor)]
        for i in 0..<length {
            if i > 0 && i & 7 == 0 {
                try seek(by: 1)
                value = data[Data.Index(cursor)]
            }
            let bitPosition = i & 7
            result.append((value & (1 << bitPosition)) != 0)
        }
        try seek(by: 1)
        return result
    }

    public func readAndSeekVTable() throws -> [Int64?] {
        let rootCursor = cursor
        let offset = try readAndSeekSignedLEB()
        let offsetCursor = cursor
        if offset < 0 {
            cursor = rootCursor
        }
        try seek(by: offset)
        let countLEB = try readAndSeekLEB()
        let is16Bit = countLEB & 1 == 1
        let count = Int(countLEB >> 1)
        var result = [Int64?]()
        if is16Bit {
            for _ in 0..<count {
                let value: UInt16 = try readAndSeekNumeric()
                if value == 0 {
                    result.append(nil)
                } else {
                    result.append(Int64(value) - 1)
                }
            }
        } else {
            for _ in 0..<count {
                let value: UInt8 = try readAndSeekNumeric()
                if value == 0 {
                    result.append(nil)
                } else {
                    result.append(Int64(value) - 1)
                }
            }
        }
        try seek(to: offsetCursor)
        return result
    }

    public func readAndSeekSparseVTable() throws -> [UInt16: Int64] {
        let rootCursor = cursor
        let offsetLEB = try readAndSeekLEB()
        let offsetCursor = cursor
        cursor = rootCursor
        let offset = offsetLEB.fromZigZag
        try seek(by: offset)
        let countLEB = try readAndSeekLEB()
        let is16Bit = countLEB & 1 == 1
        let count = Int(countLEB >> 1)
        var result = [UInt16: Int64]()
        if is16Bit {
            for _ in 0..<count {
                let index: UInt16 = try readAndSeekNumeric()
                let value: UInt16 = try readAndSeekNumeric()
                result[index] = Int64(value)
            }
        } else {
            for _ in 0..<count {
                let index: UInt8 = try readAndSeekNumeric()
                let value: UInt8 = try readAndSeekNumeric()
                result[UInt16(index)] = Int64(value)
            }
        }
        try seek(to: offsetCursor)
        return result
    }

    public func readAndSeekArrayPointers(encodedLength: UInt64) throws -> [Int64] {
        let arrayLength = encodedLength >> 2
        let widthCode = encodedLength & 3
        if widthCode == 0 {
            return try (0..<arrayLength).map { _ in
                let value: UInt8 = try readAndSeekNumeric()
                return Int64(value)
            }
        }
        if widthCode == 1 {
            return try (0..<arrayLength).map { _ in
                let value: UInt16 = try readAndSeekNumeric()
                return Int64(value)
            }
        }
        if widthCode == 2 {
            return try (0..<arrayLength).map { _ in
                let value: UInt32 = try readAndSeekNumeric()
                return Int64(value)
            }
        }
        return try (0..<arrayLength).map { _ in
            let value: UInt64 = try readAndSeekNumeric()
            return Int64(value)
        }
    }

    public func readAndSeekUIntArray(encodedLength: UInt64) throws -> [UInt64] {
        let arrayLength = encodedLength >> 2
        let widthCode = encodedLength & 3
        if widthCode == 0 {
            return try (0..<arrayLength).map { _ in
                let value: UInt8 = try readAndSeekNumeric()
                return UInt64(value)
            }
        }
        if widthCode == 1 {
            return try (0..<arrayLength).map { _ in
                let value: UInt16 = try readAndSeekNumeric()
                return UInt64(value)
            }
        }
        if widthCode == 2 {
            return try (0..<arrayLength).map { _ in
                let value: UInt32 = try readAndSeekNumeric()
                return UInt64(value)
            }
        }
        return try (0..<arrayLength).map { _ in
            let value: UInt64 = try readAndSeekNumeric()
            return UInt64(value)
        }
    }

    public func readAndSeekFourBitArray() throws -> [UInt8] {
        let length = try readAndSeekLEB()
        return try readAndSeekFourBitArrayWithLength(length: length)
    }

    public func readAndSeekFourBitArrayWithLength(length: UInt64) throws -> [UInt8] {
        var result = [UInt8]()
        let byteCount = (length >> 1) + (length & 1)
        for _ in 0..<byteCount {
            let value: UInt8 = try readAndSeekNumeric()
            result.append(value & 15)
            if result.count < length {
                result.append(value >> 4)
            }
        }
        return result
    }

    public func readAndSeekTwoBitArray() throws -> [UInt8] {
        let length = try readAndSeekLEB()
        return try readAndSeekTwoBitArrayWithLength(length: length)
    }

    public func readAndSeekTwoBitArrayWithLength(length: UInt64) throws -> [UInt8] {
        var result = [UInt8]()
        let byteCount = (length >> 2) + (length & 3 > 0 ? 1 : 0)
        for _ in 0..<byteCount {
            var value: UInt8 = try readAndSeekNumeric()
            result.append(value & 3)
            for _ in 0..<3 {
                value >>= 2
                if result.count < length {
                    result.append(value & 3)
                }
            }
        }
        return result
    }

    public func readAndSeekSingleBitArray() throws -> [UInt8] {
        // TODO: optimize
        return try readAndSeekBoolArray().map { $0 ? 1 : 0}
    }

    public func readAndSeekSingleBitArrayWithLength(length: UInt64) throws -> [UInt8] {
        // TODO: optimize
        return try readAndSeekBoolArrayWithLength(length: length).map { $0 ? 1 : 0}
    }

    public func readAndSeekNumericArray<T: Numeric>() throws -> [T] {
        let arrayLength = try readAndSeekLEB()
        return try readAndSeekNumericArrayWithLength(length: arrayLength)
    }

    public func readAndSeekNumericArrayWithLength<T>(length: UInt64) throws -> [T] where T : Numeric {
        return try (0..<length).map {_ -> T in
            try readAndSeekNumeric()
        }
    }

    public func getStructNode<T: Node>(from offset: UInt64) throws -> (T, Bool) {
        if let structNode =  structCache[offset] {
            guard let structNode = structNode as? T else {
                throw ReaderError.badStructOffset
            }
            return (structNode, true)
        }
        let newInstance = T.init()
        structCache[offset] = newInstance
        return (newInstance, false)
    }

    public func readAndSeekNumericArrayWithOptionals<T: Numeric>() throws -> [T?] {
            let bitSet = try readAndSeekBoolArray()
            var result = [T?]()
            for index in 0..<bitSet.count {
                let value: T = try readAndSeekNumeric()
                result.append(bitSet[index] ? value : nil)
            }
            return result
        }

    public func readAndSeekBoolArrayWithOptionals() throws -> [Bool?] {
        let bitSet = try readAndSeekBoolArray()
        let values = try readAndSeekBoolArrayWithLength(length: UInt64(bitSet.count))
        var result = [Bool?]()
        for index in 0..<bitSet.count {
            result.append(bitSet[index] ? values[index] : nil)
        }
        return result
    }

    public func readAndSeekStringArray() throws -> [String] {
        let encodedLength = try readAndSeekLEB()
        let stringOffsets = try readAndSeekArrayPointers(encodedLength: encodedLength)
        return try stringOffsets.map {
            guard $0 > 0 else {
                throw ReaderError.badOffset($0)
            }
            let arrayEndOffset = cursor
            try seek(by: Int64($0 - 1))
            let value = try readSting()
            try seek(to: arrayEndOffset)
            return value
        }
    }

    public func readAndSeekStringArrayWithOptionals() throws -> [String?] {
        let encodedLength = try readAndSeekLEB()
        let stringOffsets = try readAndSeekArrayPointers(encodedLength: encodedLength)
        return try stringOffsets.map {
            guard $0 > 0 else {
                if $0 == 0 { return nil }
                throw ReaderError.badOffset($0)
            }
            let arrayEndOffset = cursor
            try seek(by: Int64($0 - 1))
            let value = try readSting()
            try seek(to: arrayEndOffset)
            return value
        }
    }

    public func readAndSeekDataArray() throws -> [Data] {
        let encodedLength = try readAndSeekLEB()
        let stringOffsets = try readAndSeekArrayPointers(encodedLength: encodedLength)
        return try stringOffsets.map {
            guard $0 > 0 else {
                throw ReaderError.badOffset($0)
            }
            let arrayEndOffset = cursor
            try seek(by: Int64($0 - 1))
            let value = try readData()
            try seek(to: arrayEndOffset)
            return value
        }
    }

    public func readAndSeekDataArrayWithOptionals() throws -> [Data?] {
        let encodedLength = try readAndSeekLEB()
        let stringOffsets = try readAndSeekArrayPointers(encodedLength: encodedLength)
        return try stringOffsets.map {
            guard $0 > 0 else {
                if $0 == 0 { return nil }
                throw ReaderError.badOffset($0)
            }
            let arrayEndOffset = cursor
            try seek(by: Int64($0 - 1))
            let value = try readData()
            try seek(to: arrayEndOffset)
            return value
        }
    }

    public func readAndSeekStructArray<T: Node>() throws -> [T] {
        let encodedLength = try readAndSeekLEB()
        let structOffsets = try readAndSeekArrayPointers(encodedLength: encodedLength)
        let arrayEndOffset = cursor
        return try structOffsets.map {
            guard $0 > 0 else {
                throw ReaderError.badOffset($0)
            }
            var relativeOffset = UInt64($0).fromZigZag
            if relativeOffset > 0 {
                relativeOffset -= 1
            }
            try seek(by: relativeOffset)
            let value = try T.with(reader: self, offset: cursor)
            try seek(to: arrayEndOffset)
            return value
        }
    }

    public func readAndSeekStructArrayWithOptionals<T: Node>() throws -> [T?] {
        let encodedLength = try readAndSeekLEB()
        let structOffsets = try readAndSeekArrayPointers(encodedLength: encodedLength)
        let arrayEndOffset = cursor
        return try structOffsets.map {
            guard $0 > 0 else {
                if $0 == 0 { return nil }
                throw ReaderError.badOffset($0)
            }
            var relativeOffset = UInt64($0).fromZigZag
            if relativeOffset > 0 {
                relativeOffset -= 1
            }
            try seek(by: relativeOffset)
            let value = try T.with(reader: self, offset: cursor)
            try seek(to: arrayEndOffset)
            return value
        }
    }

    public func readAndSeekEnum<T: EnumNode>() throws -> T {
        switch T.byteWidth {
        case .eighth, .quarter, .half, .one:
            let value: UInt8 = try readAndSeekNumeric()
            guard let result = T.from(value: UInt64(value)) else { throw ReaderError.unfittingEnumValue }
            return result
        case .two:
            let value: UInt16 = try readAndSeekNumeric()
            guard let result = T.from(value: UInt64(value)) else { throw ReaderError.unfittingEnumValue }
            return result
        case .four:
            let value: UInt32 = try readAndSeekNumeric()
            guard let result = T.from(value: UInt64(value)) else { throw ReaderError.unfittingEnumValue }
            return result
        case .eight:
            let value: UInt64 = try readAndSeekNumeric()
            guard let result = T.from(value: value) else { throw ReaderError.unfittingEnumValue }
            return result
        }
    }

    public func readAndSeekEnumArray<T: EnumNode>() throws -> [T] {
        switch T.byteWidth {
        case .eighth:
            return try readAndSeekSingleBitArray().map {
                guard let value = T.from(value: UInt64($0)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .quarter:
            return try readAndSeekTwoBitArray().map {
                guard let value = T.from(value: UInt64($0)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .half:
            return try readAndSeekFourBitArray().map {
                guard let value = T.from(value: UInt64($0)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .one:
            return try readAndSeekNumericArray().map { (num: UInt8) -> T in
                guard let value = T.from(value: UInt64(num)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .two:
            return try readAndSeekNumericArray().map { (num: UInt16) -> T in
                guard let value = T.from(value: UInt64(num)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .four:
            return try readAndSeekNumericArray().map { (num: UInt32) -> T in
                guard let value = T.from(value: UInt64(num)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .eight:
            return try readAndSeekNumericArray().map { (num: UInt64) -> T in
                guard let value = T.from(value: num) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        }
    }

    public func readAndSeekEnumArrayWithOptionals<T: EnumNode>() throws -> [T?] {
        let mask = try readAndSeekBoolArray()
        let length = UInt64(mask.count)
        switch T.byteWidth {
        case .eighth:
            return try readAndSeekSingleBitArrayWithLength(length: length).enumerated().map {
                guard mask[$0] else { return nil }
                guard let value = T.from(value: UInt64($1)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .quarter:
            return try readAndSeekTwoBitArrayWithLength(length: length).enumerated().map {
                guard mask[$0] else { return nil }
                guard let value = T.from(value: UInt64($1)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .half:
            return try readAndSeekFourBitArrayWithLength(length: length).enumerated().map {
                guard mask[$0] else { return nil }
                guard let value = T.from(value: UInt64($1)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .one:
            return try readAndSeekNumericArrayWithLength(length: length).enumerated().map { (tuple: (Int, UInt8)) -> T? in
                guard mask[tuple.0] else { return nil }
                guard let value = T.from(value: UInt64(tuple.1)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .two:
            return try readAndSeekNumericArrayWithLength(length: length).enumerated().map { (tuple: (Int, UInt16)) -> T? in
                guard mask[tuple.0] else { return nil }
                guard let value = T.from(value: UInt64(tuple.1)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .four:
            return try readAndSeekNumericArrayWithLength(length: length).enumerated().map { (tuple: (Int, UInt32)) -> T? in
                guard mask[tuple.0] else { return nil }
                guard let value = T.from(value: UInt64(tuple.1)) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        case .eight:
            return try readAndSeekNumericArrayWithLength(length: length).enumerated().map { (tuple: (Int, UInt64)) -> T? in
                guard mask[tuple.0] else { return nil }
                guard let value = T.from(value: tuple.1) else { throw ReaderError.unfittingEnumValue }
                return value
            }
        }
    }

    public func readAndSeekUnionTypeArray<T: UnionNode>() throws -> [T] {
        let encodedLength = try readAndSeekLEB()
        let typeIds: [UInt64]
        switch T.byteWidth {
        case .eighth:
            typeIds = try readAndSeekSingleBitArrayWithLength(length: encodedLength >> 2).map { UInt64($0) }
        case .quarter:
            typeIds = try readAndSeekTwoBitArrayWithLength(length: encodedLength >> 2).map { UInt64($0) }
        case .half:
            typeIds = try readAndSeekFourBitArrayWithLength(length: encodedLength >> 2).map { UInt64($0) }
        case .one:
            typeIds = try readAndSeekNumericArrayWithLength(length: encodedLength >> 2).map { (num: UInt8) -> UInt64 in UInt64(num) }
        case .two:
            typeIds = try readAndSeekNumericArrayWithLength(length: encodedLength >> 2).map { (num: UInt16) -> UInt64 in UInt64(num) }
        case .four:
            typeIds = try readAndSeekNumericArrayWithLength(length: encodedLength >> 2).map { (num: UInt32) -> UInt64 in UInt64(num) }
        case .eight:
            typeIds = try readAndSeekNumericArrayWithLength(length: encodedLength >> 2)
        }
        let values = try readAndSeekUIntArray(encodedLength: encodedLength)
        let currentStart = cursor
        var result = [T]()
        for index in 0..<typeIds.count {
            try seek(to: currentStart)
            guard let unionType = try T.from(typeId: typeIds[index], value: values[index], reader: self, offset: currentStart) else { throw ReaderError.unfittingUnionType }
            result.append(unionType)
        }
        return result
    }

    public func readAndSeekUnionTypeArrayWithOptionals<T: UnionNode>() throws -> [T?] {
        let encodedLength = try readAndSeekLEB()
        let length = encodedLength >> 2
        let mask = try readAndSeekBoolArrayWithLength(length: length)
        let typeIds: [UInt64]
        switch T.byteWidth {
        case .eighth:
            typeIds = try readAndSeekSingleBitArrayWithLength(length: length).map { UInt64($0) }
        case .quarter:
            typeIds = try readAndSeekTwoBitArrayWithLength(length: length).map { UInt64($0) }
        case .half:
            typeIds = try readAndSeekFourBitArrayWithLength(length: length).map { UInt64($0) }
        case .one:
            typeIds = try readAndSeekNumericArrayWithLength(length: length).map { (num: UInt8) -> UInt64 in UInt64(num) }
        case .two:
            typeIds = try readAndSeekNumericArrayWithLength(length: length).map { (num: UInt16) -> UInt64 in UInt64(num) }
        case .four:
            typeIds = try readAndSeekNumericArrayWithLength(length: length).map { (num: UInt32) -> UInt64 in UInt64(num) }
        case .eight:
            typeIds = try readAndSeekNumericArrayWithLength(length: length)
        }
        let values = try readAndSeekUIntArray(encodedLength: encodedLength)
        let currentStart = cursor
        var result = [T?]()
        for index in 0..<typeIds.count {
            try seek(to: currentStart)
            guard mask[index] else {
                result.append(nil)
                continue
            }
            guard let unionType = try T.from(typeId: typeIds[index], value: values[index], reader: self, offset: currentStart) else { throw ReaderError.unfittingUnionType }
            result.append(unionType)
        }
        return result
    }
}
