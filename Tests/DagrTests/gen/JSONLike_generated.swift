//  Generated with Dagr on 07.10.25.
//  https://github.com/mzaks/dagr
//

import Dagr
import Foundation

public enum JSONLike {
    public static func encode(root: Value) throws -> Data {
        let builder = DataBuilder()
        let unionType = try root.apply(builder: builder)
        _ = try builder.store(unionType: unionType)
        return builder.makeData
    }

    public static func decode(data: Data) throws -> Value {
        let reader = DataReader(data: data)
        let typeId = try reader.readAndSeekLEB()
        let currentOffset = reader.cursor
        let value = try reader.readAndSeekLEB()
        guard let unionType = try Value.from(typeId: typeId, value: value, reader: reader, offset: currentOffset) else {
            throw ReaderError.unexpectedUnionCase
        }
        return unionType
    }

    public final class Pair: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var key: String! = nil
        public var value: Value? = nil

        public init() {}

        public init(key: String, value: Value? = nil) {
            self.key = key
            self.value = value
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let keyPointer = try builder.store(string: key)
            let valueAppliedValue = try value?.apply(builder: builder)

            _ = try valueAppliedValue.map { try builder.store(unionType: $0) }
            _ = try builder.storeForwardPointer(value: keyPointer)

            return try builder.store(inline: [value != nil].bitSet)

        }


        public func cycleAwareEquality(other: Pair, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)
            let isValueEqual: Bool
            if let value = value, let otherValue = other.value {
                isValueEqual = value.cycleAwareEquality(other: otherValue, visited: &visited)
            } else {
                isValueEqual = value == other.value
            }

            return self.key == other.key
                && isValueEqual

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(key)
            value?.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Pair {
            var result: Pair
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let optionalFields = try reader.readAndSeekBoolArrayWithLength(length: 1)
            do {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.key = try reader.readSting()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[0] {
                let typeId = try reader.readAndSeekLEB()
                let currentOffset = reader.cursor
                let value = try reader.readAndSeekLEB()
                result.value = try Value.from(typeId: typeId, value: value, reader: reader, offset: currentOffset)
            }

            return result
        }

    }

    public indirect enum Value: UnionNode, Equatable, CycleAwareEquatable, CycleAwareHashable {

        case string(String), bool(Bool), number(Float64), array([Value?]), dict([Pair])

        public var typeId: UInt64 {
            switch self {
                case .string: return 0
                case .bool: return 1
                case .number: return 2
                case .array: return 3
                case .dict: return 4
            }
        }

        public static var byteWidth: ByteWidth { .half }

        public func cycleAwareEquality(other: Self, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            switch self {
                case .string(let selfValue):
                    if case .string(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .bool(let selfValue):
                    if case .bool(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .number(let selfValue):
                    if case .number(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .array(let selfValue):
                    if case .array(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .dict(let selfValue):
                    if case .dict(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
            }
        }

        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
                    switch self {
                case .string(let value):
                    value.hash(into: &hasher)
                case .bool(let value):
                    value.hash(into: &hasher)
                case .number(let value):
                    value.hash(into: &hasher)
                case .array(let selfArray):
                    selfArray.hash(into: &hasher, visited: &visited)
                case .dict(let selfDict):
                    selfDict.hash(into: &hasher, visited: &visited)
            }
        }

        public func apply(builder: Builder) throws -> AppliedUnionType {
            switch self {
                case .string(let value):
                    return .pointer(value: try builder.store(string: value), id: 0)
                case .bool(let value):
                    return .value(value: value ? 1 : 0, id: 1)
                case .number(let value):
                    return .value(value: UInt64(value.bitPattern), id: 2)
                case .array(let value):
                    return .pointer(value: try builder.storeWithOptionals(unionTypes: value), id: 3)
                case .dict(let value):
                    return .pointer(value: try builder.store(structNodes: value), id: 4)
            }
        }

        public static func from<T: Reader>(typeId: UInt64, value: UInt64, reader: T, offset: UInt64) throws -> Value? {
            if typeId == 0 {
                try reader.seek(by: Int64(value))
                return try .string(reader.readAndSeekSting())
            }
            if typeId == 1 {
                return .bool(value == 1 ? true : false)
            }
            if typeId == 2 {
                return .number(Float64(bitPattern: value))
            }
            if typeId == 3 {
                try reader.seek(by: Int64(value))
                return try .array(reader.readAndSeekUnionTypeArrayWithOptionals())
            }
            if typeId == 4 {
                try reader.seek(by: Int64(value))
                return try .dict(reader.readAndSeekStructArray())
            }
            return nil
        }
    }

}
