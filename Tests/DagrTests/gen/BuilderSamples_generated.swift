//  Generated with Dagr on 07.10.25.
//  https://github.com/mzaks/dagr
//

import Dagr
import Foundation
import FoundationNodes

public enum BuilderSamples {
    public static func encode(root: [Types]) throws -> Data {
        let builder = DataBuilder()
        _ = try builder.store(unionTypes: root)
        return builder.makeData
    }

    public static func decode(data: Data) throws -> [Types] {
        let reader = DataReader(data: data)
        return try reader.readAndSeekUnionTypeArray()
    }

    public enum Types: UnionNode, Equatable, CycleAwareEquatable, CycleAwareHashable {

        case Person1(Person1), Person2(Person2), Person3(Person3), Person4(Person4), Person5(Person5), Person6(Person6), Person7(Person7), Person8(Person8), Person9(Person9), Person10(Person10), Person11(Person11), Person12(Person12), StringDict1(StringDict1), StringDict2(StringDict2), StringDict3(StringDict3), StringDict4(StringDict4), StringDict5(StringDict5), StringDict6(StringDict6)

        public var typeId: UInt64 {
            switch self {
                case .Person1: return 0
                case .Person2: return 1
                case .Person3: return 2
                case .Person4: return 3
                case .Person5: return 4
                case .Person6: return 5
                case .Person7: return 6
                case .Person8: return 7
                case .Person9: return 8
                case .Person10: return 9
                case .Person11: return 10
                case .Person12: return 11
                case .StringDict1: return 12
                case .StringDict2: return 13
                case .StringDict3: return 14
                case .StringDict4: return 15
                case .StringDict5: return 16
                case .StringDict6: return 17
            }
        }

        public static var byteWidth: ByteWidth { .two }

        public func cycleAwareEquality(other: Self, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            switch self {
                case .Person1(let selfValue):
                    if case .Person1(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person2(let selfValue):
                    if case .Person2(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person3(let selfValue):
                    if case .Person3(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person4(let selfValue):
                    if case .Person4(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person5(let selfValue):
                    if case .Person5(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person6(let selfValue):
                    if case .Person6(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person7(let selfValue):
                    if case .Person7(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person8(let selfValue):
                    if case .Person8(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person9(let selfValue):
                    if case .Person9(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person10(let selfValue):
                    if case .Person10(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person11(let selfValue):
                    if case .Person11(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .Person12(let selfValue):
                    if case .Person12(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .StringDict1(let selfValue):
                    if case .StringDict1(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .StringDict2(let selfValue):
                    if case .StringDict2(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .StringDict3(let selfValue):
                    if case .StringDict3(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .StringDict4(let selfValue):
                    if case .StringDict4(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .StringDict5(let selfValue):
                    if case .StringDict5(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
                case .StringDict6(let selfValue):
                    if case .StringDict6(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
            }
        }

        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
                    switch self {
                case .Person1(let selfPerson1):
                    selfPerson1.hash(into: &hasher, visited: &visited)
                case .Person2(let selfPerson2):
                    selfPerson2.hash(into: &hasher, visited: &visited)
                case .Person3(let selfPerson3):
                    selfPerson3.hash(into: &hasher, visited: &visited)
                case .Person4(let selfPerson4):
                    selfPerson4.hash(into: &hasher, visited: &visited)
                case .Person5(let selfPerson5):
                    selfPerson5.hash(into: &hasher, visited: &visited)
                case .Person6(let selfPerson6):
                    selfPerson6.hash(into: &hasher, visited: &visited)
                case .Person7(let selfPerson7):
                    selfPerson7.hash(into: &hasher, visited: &visited)
                case .Person8(let selfPerson8):
                    selfPerson8.hash(into: &hasher, visited: &visited)
                case .Person9(let selfPerson9):
                    selfPerson9.hash(into: &hasher, visited: &visited)
                case .Person10(let selfPerson10):
                    selfPerson10.hash(into: &hasher, visited: &visited)
                case .Person11(let selfPerson11):
                    selfPerson11.hash(into: &hasher, visited: &visited)
                case .Person12(let selfPerson12):
                    selfPerson12.hash(into: &hasher, visited: &visited)
                case .StringDict1(let selfStringdict1):
                    selfStringdict1.hash(into: &hasher, visited: &visited)
                case .StringDict2(let selfStringdict2):
                    selfStringdict2.hash(into: &hasher, visited: &visited)
                case .StringDict3(let selfStringdict3):
                    selfStringdict3.hash(into: &hasher, visited: &visited)
                case .StringDict4(let selfStringdict4):
                    selfStringdict4.hash(into: &hasher, visited: &visited)
                case .StringDict5(let selfStringdict5):
                    selfStringdict5.hash(into: &hasher, visited: &visited)
                case .StringDict6(let selfStringdict6):
                    selfStringdict6.hash(into: &hasher, visited: &visited)
            }
        }

        public func apply(builder: Builder) throws -> AppliedUnionType {
            switch self {
                case .Person1(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 0)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 0)
                    }
                case .Person2(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 1)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 1)
                    }
                case .Person3(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 2)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 2)
                    }
                case .Person4(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 3)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 3)
                    }
                case .Person5(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 4)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 4)
                    }
                case .Person6(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 5)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 5)
                    }
                case .Person7(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 6)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 6)
                    }
                case .Person8(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 7)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 7)
                    }
                case .Person9(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 8)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 8)
                    }
                case .Person10(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 9)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 9)
                    }
                case .Person11(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 10)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 10)
                    }
                case .Person12(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 11)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 11)
                    }
                case .StringDict1(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 12)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 12)
                    }
                case .StringDict2(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 13)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 13)
                    }
                case .StringDict3(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 14)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 14)
                    }
                case .StringDict4(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 15)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 15)
                    }
                case .StringDict5(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 16)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 16)
                    }
                case .StringDict6(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 17)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 17)
                    }
            }
        }

        public static func from<T: Reader>(typeId: UInt64, value: UInt64, reader: T, offset: UInt64) throws -> Types? {
            if typeId == 0 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person1(BuilderSamples.Person1.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 1 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person2(BuilderSamples.Person2.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 2 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person3(BuilderSamples.Person3.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 3 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person4(BuilderSamples.Person4.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 4 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person5(BuilderSamples.Person5.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 5 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person6(BuilderSamples.Person6.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 6 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person7(BuilderSamples.Person7.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 7 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person8(BuilderSamples.Person8.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 8 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person9(BuilderSamples.Person9.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 9 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person10(BuilderSamples.Person10.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 10 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person11(BuilderSamples.Person11.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 11 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .Person12(BuilderSamples.Person12.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 12 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .StringDict1(BuilderSamples.StringDict1.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 13 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .StringDict2(BuilderSamples.StringDict2.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 14 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .StringDict3(BuilderSamples.StringDict3.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 15 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .StringDict4(BuilderSamples.StringDict4.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 16 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .StringDict5(BuilderSamples.StringDict5.with(reader: reader, offset: reader.cursor))
            }
            if typeId == 17 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .StringDict6(BuilderSamples.StringDict6.with(reader: reader, offset: reader.cursor))
            }
            return nil
        }
    }

    public final class Person1: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var name: String? = nil
        public var age: UInt8? = nil

        public init() {}

        public init(name: String? = nil, age: UInt8? = nil) {
            self.name = name
            self.age = age
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let namePointer = try name.map { try builder.store(string: $0) }

            let ageValueCursor = try age.map { try builder.store(number: $0) }
            let namePointerCursor = try builder.storeForwardPointer(value: namePointer)

            return try builder.store(vTable: [namePointerCursor, ageValueCursor])

        }


        public func cycleAwareEquality(other: Person1, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.name == other.name
                && self.age == other.age

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(name)
            hasher.combine(age)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person1 {
            var result: Person1
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let nameOffset = vTable[0] {
                try reader.seek(by: nameOffset)
                let stringPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(stringPointer))
                result.name = try reader.readSting()
            } else {
                result.name = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let ageOffset = vTable[1] {
                try reader.seek(by: ageOffset)
                result.age = try reader.readAndSeekNumeric()
            } else {
                result.age = nil
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class Person2: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var name: String? = nil
        public var age: UInt8? = nil

        public init() {}

        public init(name: String? = nil, age: UInt8? = nil) {
            self.name = name
            self.age = age
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let namePointer = try name.map { try builder.store(string: $0) }

            _ = try age.map { try builder.store(number: $0) }
            _ = try builder.storeForwardPointer(value: namePointer)

            return try builder.store(inline: [name != nil, age != nil].bitSet)

        }


        public func cycleAwareEquality(other: Person2, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.name == other.name
                && self.age == other.age

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(name)
            hasher.combine(age)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person2 {
            var result: Person2
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let optionalFields = try reader.readAndSeekBoolArrayWithLength(length: 2)
            if optionalFields[0] {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.name = try reader.readSting()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[1] {
                result.age = try reader.readAndSeekNumeric()
            }

            return result
        }

    }

    public final class Person3: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var name: String? = nil
        public var age: UInt8? = nil

        public init() {}

        public init(name: String? = nil, age: UInt8? = nil) {
            self.name = name
            self.age = age
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let namePointer = try name.map { try builder.store(string: $0) }

            let ageValueCursor = try age.map { try builder.store(number: $0) }
            let namePointerCursor = try builder.storeForwardPointer(value: namePointer)

            return try builder.storeSparse(vTable: [namePointerCursor, ageValueCursor])

        }


        public func cycleAwareEquality(other: Person3, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.name == other.name
                && self.age == other.age

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(name)
            hasher.combine(age)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person3 {
            var result: Person3
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekSparseVTable()
            let vTableStartOffest = reader.cursor
            if let nameOffset = vTable[0] {
                try reader.seek(by: nameOffset)
                let stringPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(stringPointer))
                result.name = try reader.readSting()
            } else {
                result.name = nil
            }
            try reader.seek(to: vTableStartOffest)
            if let ageOffset = vTable[1] {
                try reader.seek(by: ageOffset)
                result.age = try reader.readAndSeekNumeric()
            } else {
                result.age = nil
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class MyDate: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var day: UInt8! = nil
        public var month: UInt8! = nil
        public var year: UInt16! = nil

        public init() {}

        public init(day: UInt8, month: UInt8, year: UInt16) {
            self.day = day
            self.month = month
            self.year = year
        }


        nonisolated(unsafe) public static let millennium = MyDate(day: 1, month: 1, year: 2000)


        public func apply(builder: Builder) throws -> UInt64 {

            _ = try builder.store(number: year)
            _ = try builder.store(number: month)
            _ = try builder.store(number: day)

            return builder.cursor

        }


        public func cycleAwareEquality(other: MyDate, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.day == other.day
                && self.month == other.month
                && self.year == other.year

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(day)
            hasher.combine(month)
            hasher.combine(year)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> MyDate {
            var result: MyDate
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            do {
                result.day = try reader.readAndSeekNumeric()
            }
            do {
                result.month = try reader.readAndSeekNumeric()
            }
            do {
                result.year = try reader.readAndSeekNumeric()
            }

            return result
        }

    }

    public final class Person4: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var name: String? = nil
        public var age: UInt8? = nil
        public var date: MyDate? = nil

        public init() {}

        public init(name: String? = nil, age: UInt8? = nil, date: MyDate? = nil) {
            self.name = name
            self.age = age
            self.date = date
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let namePointer = try name.map { try builder.store(string: $0) }
            let datePointer = try date.flatMap { try builder.store(structNode: $0) }

            var datePointerCursor: UInt64?
            if let date = date{
                if let pointer = datePointer {
                    datePointerCursor = try builder.storeBidirectionalPointer(value: pointer)
                } else {
                    datePointerCursor = try builder.reserveFieldPointer(for: date)
                }
            }
            let ageValueCursor = try age.map { try builder.store(number: $0) }
            let namePointerCursor = try builder.storeForwardPointer(value: namePointer)

            return try builder.store(vTable: [namePointerCursor, ageValueCursor, datePointerCursor])

        }


        public func cycleAwareEquality(other: Person4, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)
            let isDateEqual: Bool
            if let date = date, let otherDate = other.date {
                isDateEqual = date.cycleAwareEquality(other: otherDate, visited: &visited)
            } else {
                isDateEqual = date == other.date
            }

            return self.name == other.name
                && self.age == other.age
                && isDateEqual

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(name)
            hasher.combine(age)
            date?.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person4 {
            var result: Person4
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let nameOffset = vTable[0] {
                try reader.seek(by: nameOffset)
                let stringPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(stringPointer))
                result.name = try reader.readSting()
            } else {
                result.name = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let ageOffset = vTable[1] {
                try reader.seek(by: ageOffset)
                result.age = try reader.readAndSeekNumeric()
            } else {
                result.age = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 2, let dateOffset = vTable[2] {
                try reader.seek(by: dateOffset)
                let _pointerOffset = reader.cursor
                let datePointer = try reader.readAndSeekSignedLEB()
                if datePointer < 0 { try reader.seek(to: _pointerOffset) }
                result.date = try MyDate.with(reader: reader, offset:  UInt64(Int64(reader.cursor) + datePointer))
            } else {
                result.date = nil
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class Person5: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var name: String? = nil
        public var age: UInt8? = nil
        public var date: MyDate? = nil
        public var friend: Person5? = nil

        public init() {}

        public init(name: String? = nil, age: UInt8? = nil, date: MyDate? = nil, friend: Person5? = nil) {
            self.name = name
            self.age = age
            self.date = date
            self.friend = friend
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let namePointer = try name.map { try builder.store(string: $0) }
            let datePointer = try date.flatMap { try builder.store(structNode: $0) }
            let friendPointer = try friend.flatMap { try builder.store(structNode: $0) }

            var friendPointerCursor: UInt64?
            if let friend = friend{
                if let pointer = friendPointer {
                    friendPointerCursor = try builder.storeBidirectionalPointer(value: pointer)
                } else {
                    friendPointerCursor = try builder.reserveFieldPointer(for: friend)
                }
            }
            var datePointerCursor: UInt64?
            if let date = date{
                if let pointer = datePointer {
                    datePointerCursor = try builder.storeBidirectionalPointer(value: pointer)
                } else {
                    datePointerCursor = try builder.reserveFieldPointer(for: date)
                }
            }
            let ageValueCursor = try age.map { try builder.store(number: $0) }
            let namePointerCursor = try builder.storeForwardPointer(value: namePointer)

            return try builder.store(vTable: [namePointerCursor, ageValueCursor, datePointerCursor, friendPointerCursor])

        }


        public func cycleAwareEquality(other: Person5, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)
            let isDateEqual: Bool
            if let date = date, let otherDate = other.date {
                isDateEqual = date.cycleAwareEquality(other: otherDate, visited: &visited)
            } else {
                isDateEqual = date == other.date
            }
            let isFriendEqual: Bool
            if let friend = friend, let otherFriend = other.friend {
                isFriendEqual = friend.cycleAwareEquality(other: otherFriend, visited: &visited)
            } else {
                isFriendEqual = friend == other.friend
            }

            return self.name == other.name
                && self.age == other.age
                && isDateEqual
                && isFriendEqual

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(name)
            hasher.combine(age)
            date?.hash(into: &hasher, visited: &visited)
            friend?.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person5 {
            var result: Person5
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let nameOffset = vTable[0] {
                try reader.seek(by: nameOffset)
                let stringPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(stringPointer))
                result.name = try reader.readSting()
            } else {
                result.name = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let ageOffset = vTable[1] {
                try reader.seek(by: ageOffset)
                result.age = try reader.readAndSeekNumeric()
            } else {
                result.age = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 2, let dateOffset = vTable[2] {
                try reader.seek(by: dateOffset)
                let _pointerOffset = reader.cursor
                let datePointer = try reader.readAndSeekSignedLEB()
                if datePointer < 0 { try reader.seek(to: _pointerOffset) }
                result.date = try MyDate.with(reader: reader, offset:  UInt64(Int64(reader.cursor) + datePointer))
            } else {
                result.date = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 3, let friendOffset = vTable[3] {
                try reader.seek(by: friendOffset)
                let _pointerOffset = reader.cursor
                let friendPointer = try reader.readAndSeekSignedLEB()
                if friendPointer < 0 { try reader.seek(to: _pointerOffset) }
                result.friend = try Person5.with(reader: reader, offset:  UInt64(Int64(reader.cursor) + friendPointer))
            } else {
                result.friend = nil
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class Person6: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var name: String? = nil
        public var age: UInt8? = nil
        public var date: MyDate? = nil
        public var friend: Person6? = nil

        public init() {}

        public init(name: String? = nil, age: UInt8? = nil, date: MyDate? = nil, friend: Person6? = nil) {
            self.name = name
            self.age = age
            self.date = date
            self.friend = friend
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let namePointer = try name.map { try builder.store(string: $0) }
            let datePointer = try date.flatMap { try builder.store(structNode: $0) }
            let friendPointer = try friend.flatMap { try builder.store(structNode: $0) }

            if let friend = friend{
                if let pointer = friendPointer {
                    _ = try builder.storeBidirectionalPointer(value: pointer)
                } else {
                    _ = try builder.reserveFieldPointer(for: friend)
                }
            }
            if let date = date{
                if let pointer = datePointer {
                    _ = try builder.storeBidirectionalPointer(value: pointer)
                } else {
                    _ = try builder.reserveFieldPointer(for: date)
                }
            }
            _ = try age.map { try builder.store(number: $0) }
            _ = try builder.storeForwardPointer(value: namePointer)

            return try builder.store(inline: [name != nil, age != nil, date != nil, friend != nil].bitSet)

        }


        public func cycleAwareEquality(other: Person6, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)
            let isDateEqual: Bool
            if let date = date, let otherDate = other.date {
                isDateEqual = date.cycleAwareEquality(other: otherDate, visited: &visited)
            } else {
                isDateEqual = date == other.date
            }
            let isFriendEqual: Bool
            if let friend = friend, let otherFriend = other.friend {
                isFriendEqual = friend.cycleAwareEquality(other: otherFriend, visited: &visited)
            } else {
                isFriendEqual = friend == other.friend
            }

            return self.name == other.name
                && self.age == other.age
                && isDateEqual
                && isFriendEqual

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(name)
            hasher.combine(age)
            date?.hash(into: &hasher, visited: &visited)
            friend?.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person6 {
            var result: Person6
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let optionalFields = try reader.readAndSeekBoolArrayWithLength(length: 4)
            if optionalFields[0] {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.name = try reader.readSting()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[1] {
                result.age = try reader.readAndSeekNumeric()
            }
            if optionalFields[2] {
                let _pointerOffset = reader.cursor
                let datePointer = try reader.readAndSeekSignedLEB()
                let currentCursor = reader.cursor
                if datePointer < 0 { try reader.seek(to: _pointerOffset) }
                result.date = try MyDate.with(reader: reader, offset:  UInt64(Int64(reader.cursor) + datePointer))
                try reader.seek(to: currentCursor)
            }
            if optionalFields[3] {
                let _pointerOffset = reader.cursor
                let friendPointer = try reader.readAndSeekSignedLEB()
                let currentCursor = reader.cursor
                if friendPointer < 0 { try reader.seek(to: _pointerOffset) }
                result.friend = try Person6.with(reader: reader, offset:  UInt64(Int64(reader.cursor) + friendPointer))
                try reader.seek(to: currentCursor)
            }

            return result
        }

    }

    public final class Person7: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var nameList: [String] = []
        public var optionalNameList: [String?] = []
        public var ages: [UInt8] = []
        public var optionalAges: [UInt8?] = []
        public var dates: [MyDate] = []
        public var friends: [Person7?] = []
        public var bools: [Bool] = []
        public var optionalBools: [Bool?] = []

        public init() {}

        public init(nameList: [String] = [], optionalNameList: [String?] = [], ages: [UInt8] = [], optionalAges: [UInt8?] = [], dates: [MyDate] = [], friends: [Person7?] = [], bools: [Bool] = [], optionalBools: [Bool?] = []) {
            self.nameList = nameList
            self.optionalNameList = optionalNameList
            self.ages = ages
            self.optionalAges = optionalAges
            self.dates = dates
            self.friends = friends
            self.bools = bools
            self.optionalBools = optionalBools
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let nameListPointer = nameList.isEmpty ? nil : try builder.store(strings: nameList)
            let optionalNameListPointer = optionalNameList.isEmpty ? nil : try builder.store(strings: optionalNameList)
            let agesPointer = ages.isEmpty ? nil : try builder.store(numbers: ages)
            let optionalAgesPointer = optionalAges.isEmpty ? nil : try builder.storeWithOptionals(numbers: optionalAges)
            let datesPointer = dates.isEmpty ? nil : try builder.store(structNodes: dates)
            let friendsPointer = friends.isEmpty ? nil : try builder.store(structNodes: friends)
            let boolsPointer = bools.isEmpty ? nil : try builder.store(bools: bools)
            let optionalBoolsPointer = optionalBools.isEmpty ? nil : try builder.storeWithOptionals(bools: optionalBools)

            let optionalBoolsPointerCursor = try builder.storeForwardPointer(value: optionalBoolsPointer)
            let boolsPointerCursor = try builder.storeForwardPointer(value: boolsPointer)
            let friendsPointerCursor = try builder.storeForwardPointer(value: friendsPointer)
            let datesPointerCursor = try builder.storeForwardPointer(value: datesPointer)
            let optionalAgesPointerCursor = try builder.storeForwardPointer(value: optionalAgesPointer)
            let agesPointerCursor = try builder.storeForwardPointer(value: agesPointer)
            let optionalNameListPointerCursor = try builder.storeForwardPointer(value: optionalNameListPointer)
            let nameListPointerCursor = try builder.storeForwardPointer(value: nameListPointer)

            return try builder.store(vTable: [nameListPointerCursor, optionalNameListPointerCursor, agesPointerCursor, optionalAgesPointerCursor, datesPointerCursor, friendsPointerCursor, boolsPointerCursor, optionalBoolsPointerCursor])

        }


        public func cycleAwareEquality(other: Person7, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.nameList == other.nameList
                && self.optionalNameList == other.optionalNameList
                && self.ages == other.ages
                && self.optionalAges == other.optionalAges
                && self.dates.cycleAwareEquality(other: other.dates, visited: &visited)
                && self.friends.cycleAwareEquality(other: other.friends, visited: &visited)
                && self.bools == other.bools
                && self.optionalBools == other.optionalBools

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(nameList)
            hasher.combine(optionalNameList)
            hasher.combine(ages)
            hasher.combine(optionalAges)
            dates.hash(into: &hasher, visited: &visited)
            friends.hash(into: &hasher, visited: &visited)
            hasher.combine(bools)
            hasher.combine(optionalBools)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person7 {
            var result: Person7
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let nameListOffset = vTable[0] {
                try reader.seek(by: nameListOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.nameList = try reader.readAndSeekStringArray()
            } else {
                result.nameList = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let optionalNameListOffset = vTable[1] {
                try reader.seek(by: optionalNameListOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.optionalNameList = try reader.readAndSeekStringArrayWithOptionals()
            } else {
                result.optionalNameList = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 2, let agesOffset = vTable[2] {
                try reader.seek(by: agesOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.ages = try reader.readAndSeekNumericArray()
            } else {
                result.ages = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 3, let optionalAgesOffset = vTable[3] {
                try reader.seek(by: optionalAgesOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.optionalAges = try reader.readAndSeekNumericArrayWithOptionals()
            } else {
                result.optionalAges = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 4, let datesOffset = vTable[4] {
                try reader.seek(by: datesOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.dates = try reader.readAndSeekStructArray()
            } else {
                result.dates = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 5, let friendsOffset = vTable[5] {
                try reader.seek(by: friendsOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.friends = try reader.readAndSeekStructArrayWithOptionals()
            } else {
                result.friends = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 6, let boolsOffset = vTable[6] {
                try reader.seek(by: boolsOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.bools = try reader.readAndSeekBoolArray()
            } else {
                result.bools = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 7, let optionalBoolsOffset = vTable[7] {
                try reader.seek(by: optionalBoolsOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.optionalBools = try reader.readAndSeekBoolArrayWithOptionals()
            } else {
                result.optionalBools = []
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class Person8: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var nameList: [String] = []
        public var optionalNameList: [String?] = []
        public var ages: [UInt8] = []
        public var optionalAges: [UInt8?] = []
        public var dates: [MyDate] = []
        public var friends: [Person8?] = []
        public var bools: [Bool] = []
        public var optionalBools: [Bool?] = []

        public init() {}

        public init(nameList: [String] = [], optionalNameList: [String?] = [], ages: [UInt8] = [], optionalAges: [UInt8?] = [], dates: [MyDate] = [], friends: [Person8?] = [], bools: [Bool] = [], optionalBools: [Bool?] = []) {
            self.nameList = nameList
            self.optionalNameList = optionalNameList
            self.ages = ages
            self.optionalAges = optionalAges
            self.dates = dates
            self.friends = friends
            self.bools = bools
            self.optionalBools = optionalBools
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let nameListPointer = nameList.isEmpty ? nil : try builder.store(strings: nameList)
            let optionalNameListPointer = optionalNameList.isEmpty ? nil : try builder.store(strings: optionalNameList)
            let agesPointer = ages.isEmpty ? nil : try builder.store(numbers: ages)
            let optionalAgesPointer = optionalAges.isEmpty ? nil : try builder.storeWithOptionals(numbers: optionalAges)
            let datesPointer = dates.isEmpty ? nil : try builder.store(structNodes: dates)
            let friendsPointer = friends.isEmpty ? nil : try builder.store(structNodes: friends)
            let boolsPointer = bools.isEmpty ? nil : try builder.store(bools: bools)
            let optionalBoolsPointer = optionalBools.isEmpty ? nil : try builder.storeWithOptionals(bools: optionalBools)

            _ = try builder.storeForwardPointer(value: optionalBoolsPointer)
            _ = try builder.storeForwardPointer(value: boolsPointer)
            _ = try builder.storeForwardPointer(value: friendsPointer)
            _ = try builder.storeForwardPointer(value: datesPointer)
            _ = try builder.storeForwardPointer(value: optionalAgesPointer)
            _ = try builder.storeForwardPointer(value: agesPointer)
            _ = try builder.storeForwardPointer(value: optionalNameListPointer)
            _ = try builder.storeForwardPointer(value: nameListPointer)

            return try builder.store(inline: [nameList.isEmpty == false, optionalNameList.isEmpty == false, ages.isEmpty == false, optionalAges.isEmpty == false, dates.isEmpty == false, friends.isEmpty == false, bools.isEmpty == false, optionalBools.isEmpty == false].bitSet)

        }


        public func cycleAwareEquality(other: Person8, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.nameList == other.nameList
                && self.optionalNameList == other.optionalNameList
                && self.ages == other.ages
                && self.optionalAges == other.optionalAges
                && self.dates.cycleAwareEquality(other: other.dates, visited: &visited)
                && self.friends.cycleAwareEquality(other: other.friends, visited: &visited)
                && self.bools == other.bools
                && self.optionalBools == other.optionalBools

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(nameList)
            hasher.combine(optionalNameList)
            hasher.combine(ages)
            hasher.combine(optionalAges)
            dates.hash(into: &hasher, visited: &visited)
            friends.hash(into: &hasher, visited: &visited)
            hasher.combine(bools)
            hasher.combine(optionalBools)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person8 {
            var result: Person8
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let optionalFields = try reader.readAndSeekBoolArrayWithLength(length: 8)
            if optionalFields[0] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.nameList = try reader.readAndSeekStringArray()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[1] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.optionalNameList = try reader.readAndSeekStringArrayWithOptionals()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[2] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.ages = try reader.readAndSeekNumericArray()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[3] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.optionalAges = try reader.readAndSeekNumericArrayWithOptionals()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[4] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.dates = try reader.readAndSeekStructArray()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[5] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.friends = try reader.readAndSeekStructArrayWithOptionals()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[6] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.bools = try reader.readAndSeekBoolArray()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[7] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.optionalBools = try reader.readAndSeekBoolArrayWithOptionals()
                try reader.seek(to: currentCursor)
            }

            return result
        }

    }

    public enum Month: Int, EnumNode, Equatable, Hashable, Sendable {

        case jan = 0
        case feb = 1
        case mar = 2
        case apr = 3
        case may = 4
        case jun = 5
        case jul = 6
        case aug = 7
        case sep = 8
        case oct = 9
        case nov = 10
        case dec = 11

        public var value: UInt64 { UInt64(self.rawValue) }
        public static func from(value: UInt64) -> Month? { return Month(rawValue: Int(value)) }
        public static func tryFrom(value: UInt64) throws -> Month { guard let enumValue = Month(rawValue: Int(value)) else {throw ReaderError.unfittingEnumValue}; return enumValue }
        public static var byteWidth: ByteWidth { .half }
    }

    public enum Gender: Int, EnumNode, Equatable, Hashable, Sendable {

        case female = 0
        case male = 1
        case diverse = 2

        public var value: UInt64 { UInt64(self.rawValue) }
        public static func from(value: UInt64) -> Gender? { return Gender(rawValue: Int(value)) }
        public static func tryFrom(value: UInt64) throws -> Gender { guard let enumValue = Gender(rawValue: Int(value)) else {throw ReaderError.unfittingEnumValue}; return enumValue }
        public static var byteWidth: ByteWidth { .quarter }
    }

    public struct Toppings: OptionSet, EnumNode, Equatable, Hashable, Sendable {
            public static let pepperoni = Toppings(rawValue: 1 << 0)
            public static let onions = Toppings(rawValue: 1 << 1)
            public static let greenPeppers = Toppings(rawValue: 1 << 2)
            public static let pineapple = Toppings(rawValue: 1 << 3)

            static let all: Toppings = [
                .pepperoni,
                .onions,
                .greenPeppers,
                .pineapple,
            ]

        public var value: UInt64 { UInt64(self.rawValue) }
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public static func from(value: UInt64) -> Toppings? {
            let candidate = Toppings(rawValue: Int(value))
            if Toppings.all.isSuperset(of: candidate) {
                return candidate
            } else {
                return nil
            }
        }
        public static var byteWidth: ByteWidth { .half }
    }

    public final class Person9: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var month: Month? = nil
        public var months: [Month] = []
        public var monthsWithOptional: [Month?] = []
        public var toppings: Toppings? = nil
        public var multipleToppings: [Toppings] = []
        public var multipleOptionalToppings: [Toppings?] = []
        public var gender: Gender? = nil
        public var genders: [Gender] = []
        public var gendersWithOptional: [Gender?] = []

        public init() {}

        public init(month: Month? = nil, months: [Month] = [], monthsWithOptional: [Month?] = [], toppings: Toppings? = nil, multipleToppings: [Toppings] = [], multipleOptionalToppings: [Toppings?] = [], gender: Gender? = nil, genders: [Gender] = [], gendersWithOptional: [Gender?] = []) {
            self.month = month
            self.months = months
            self.monthsWithOptional = monthsWithOptional
            self.toppings = toppings
            self.multipleToppings = multipleToppings
            self.multipleOptionalToppings = multipleOptionalToppings
            self.gender = gender
            self.genders = genders
            self.gendersWithOptional = gendersWithOptional
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let monthsPointer = months.isEmpty ? nil : try builder.store(enums: months)
            let monthsWithOptionalPointer = monthsWithOptional.isEmpty ? nil : try builder.storeWithOptionals(enums: monthsWithOptional)
            let multipleToppingsPointer = multipleToppings.isEmpty ? nil : try builder.store(enums: multipleToppings)
            let multipleOptionalToppingsPointer = multipleOptionalToppings.isEmpty ? nil : try builder.storeWithOptionals(enums: multipleOptionalToppings)
            let gendersPointer = genders.isEmpty ? nil : try builder.store(enums: genders)
            let gendersWithOptionalPointer = gendersWithOptional.isEmpty ? nil : try builder.storeWithOptionals(enums: gendersWithOptional)

            let gendersWithOptionalPointerCursor = try builder.storeForwardPointer(value: gendersWithOptionalPointer)
            let gendersPointerCursor = try builder.storeForwardPointer(value: gendersPointer)
            let genderPointerCursor = try gender.map { try builder.store(enum: $0) }
            let multipleOptionalToppingsPointerCursor = try builder.storeForwardPointer(value: multipleOptionalToppingsPointer)
            let multipleToppingsPointerCursor = try builder.storeForwardPointer(value: multipleToppingsPointer)
            let toppingsPointerCursor = try toppings.map { try builder.store(enum: $0) }
            let monthsWithOptionalPointerCursor = try builder.storeForwardPointer(value: monthsWithOptionalPointer)
            let monthsPointerCursor = try builder.storeForwardPointer(value: monthsPointer)
            let monthPointerCursor = try month.map { try builder.store(enum: $0) }

            return try builder.store(vTable: [monthPointerCursor, monthsPointerCursor, monthsWithOptionalPointerCursor, toppingsPointerCursor, multipleToppingsPointerCursor, multipleOptionalToppingsPointerCursor, genderPointerCursor, gendersPointerCursor, gendersWithOptionalPointerCursor])

        }


        public func cycleAwareEquality(other: Person9, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.month == other.month
                && self.months == other.months
                && self.monthsWithOptional == other.monthsWithOptional
                && self.toppings == other.toppings
                && self.multipleToppings == other.multipleToppings
                && self.multipleOptionalToppings == other.multipleOptionalToppings
                && self.gender == other.gender
                && self.genders == other.genders
                && self.gendersWithOptional == other.gendersWithOptional

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(month)
            hasher.combine(months)
            hasher.combine(monthsWithOptional)
            hasher.combine(toppings)
            hasher.combine(multipleToppings)
            hasher.combine(multipleOptionalToppings)
            hasher.combine(gender)
            hasher.combine(genders)
            hasher.combine(gendersWithOptional)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person9 {
            var result: Person9
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let monthOffset = vTable[0] {
                try reader.seek(by: monthOffset)
                let monthValue: UInt8 = try reader.readAndSeekNumeric()
                result.month = Month.from(value: UInt64(monthValue))
            } else {
                result.month = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let monthsOffset = vTable[1] {
                try reader.seek(by: monthsOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.months = try reader.readAndSeekEnumArray()
            } else {
                result.months = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 2, let monthsWithOptionalOffset = vTable[2] {
                try reader.seek(by: monthsWithOptionalOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.monthsWithOptional = try reader.readAndSeekEnumArrayWithOptionals()
            } else {
                result.monthsWithOptional = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 3, let toppingsOffset = vTable[3] {
                try reader.seek(by: toppingsOffset)
                let toppingsValue: UInt8 = try reader.readAndSeekNumeric()
                result.toppings = Toppings.from(value: UInt64(toppingsValue))
            } else {
                result.toppings = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 4, let multipleToppingsOffset = vTable[4] {
                try reader.seek(by: multipleToppingsOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.multipleToppings = try reader.readAndSeekEnumArray()
            } else {
                result.multipleToppings = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 5, let multipleOptionalToppingsOffset = vTable[5] {
                try reader.seek(by: multipleOptionalToppingsOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.multipleOptionalToppings = try reader.readAndSeekEnumArrayWithOptionals()
            } else {
                result.multipleOptionalToppings = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 6, let genderOffset = vTable[6] {
                try reader.seek(by: genderOffset)
                let genderValue: UInt8 = try reader.readAndSeekNumeric()
                result.gender = Gender.from(value: UInt64(genderValue))
            } else {
                result.gender = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 7, let gendersOffset = vTable[7] {
                try reader.seek(by: gendersOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.genders = try reader.readAndSeekEnumArray()
            } else {
                result.genders = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 8, let gendersWithOptionalOffset = vTable[8] {
                try reader.seek(by: gendersWithOptionalOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.gendersWithOptional = try reader.readAndSeekEnumArrayWithOptionals()
            } else {
                result.gendersWithOptional = []
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public enum VLQ: UnionNode, Equatable, CycleAwareEquatable, CycleAwareHashable {

        case u8(UInt8), u16(UInt16), u32(UInt32), u64(UInt64)

        public var typeId: UInt64 {
            switch self {
                case .u8: return 0
                case .u16: return 1
                case .u32: return 2
                case .u64: return 3
            }
        }

        public static var byteWidth: ByteWidth { .quarter }

        public func cycleAwareEquality(other: Self, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            switch self {
                case .u8(let selfValue):
                    if case .u8(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .u16(let selfValue):
                    if case .u16(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .u32(let selfValue):
                    if case .u32(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .u64(let selfValue):
                    if case .u64(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
            }
        }

        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
                    switch self {
                case .u8(let value):
                    value.hash(into: &hasher)
                case .u16(let value):
                    value.hash(into: &hasher)
                case .u32(let value):
                    value.hash(into: &hasher)
                case .u64(let value):
                    value.hash(into: &hasher)
            }
        }

        public func apply(builder: Builder) throws -> AppliedUnionType {
            switch self {
                case .u8(let value):
                    return .value(value: UInt64(value), id: 0)
                case .u16(let value):
                    return .value(value: UInt64(value), id: 1)
                case .u32(let value):
                    return .value(value: UInt64(value), id: 2)
                case .u64(let value):
                    return .value(value: UInt64(value), id: 3)
            }
        }

        public static func from<T: Reader>(typeId: UInt64, value: UInt64, reader: T, offset: UInt64) throws -> VLQ? {
            if typeId == 0 {
                return .u8(UInt8(value))
            }
            if typeId == 1 {
                return .u16(UInt16(value))
            }
            if typeId == 2 {
                return .u32(UInt32(value))
            }
            if typeId == 3 {
                return .u64(UInt64(value))
            }
            return nil
        }
    }

    public final class Person10: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var number: VLQ? = nil
        public var numbers: [VLQ] = []
        public var optionalNumbers: [VLQ?] = []

        public init() {}

        public init(number: VLQ? = nil, numbers: [VLQ] = [], optionalNumbers: [VLQ?] = []) {
            self.number = number
            self.numbers = numbers
            self.optionalNumbers = optionalNumbers
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let numberAppliedValue = try number?.apply(builder: builder)
            let numbersPointer = numbers.isEmpty ? nil : try builder.store(unionTypes: numbers)
            let optionalNumbersPointer = optionalNumbers.isEmpty ? nil : try builder.storeWithOptionals(unionTypes: optionalNumbers)

            let optionalNumbersPointerCursor = try builder.storeForwardPointer(value: optionalNumbersPointer)
            let numbersPointerCursor = try builder.storeForwardPointer(value: numbersPointer)
            let numberPointerCursor = try numberAppliedValue.map { try builder.store(unionType: $0) }

            return try builder.store(vTable: [numberPointerCursor, numbersPointerCursor, optionalNumbersPointerCursor])

        }


        public func cycleAwareEquality(other: Person10, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)
            let isNumberEqual: Bool
            if let number = number, let otherNumber = other.number {
                isNumberEqual = number.cycleAwareEquality(other: otherNumber, visited: &visited)
            } else {
                isNumberEqual = number == other.number
            }

            return isNumberEqual
                && self.numbers.cycleAwareEquality(other: other.numbers, visited: &visited)
                && self.optionalNumbers.cycleAwareEquality(other: other.optionalNumbers, visited: &visited)

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            number?.hash(into: &hasher, visited: &visited)
            numbers.hash(into: &hasher, visited: &visited)
            optionalNumbers.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person10 {
            var result: Person10
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let numberOffset = vTable[0] {
                try reader.seek(by: numberOffset)
                let typeId = try reader.readAndSeekLEB()
                let currentOffset = reader.cursor
                let value = try reader.readAndSeekLEB()
                result.number = try VLQ.from(typeId: typeId, value: value, reader: reader, offset: currentOffset)
            } else {
                result.number = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let numbersOffset = vTable[1] {
                try reader.seek(by: numbersOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.numbers = try reader.readAndSeekUnionTypeArray()
            } else {
                result.numbers = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 2, let optionalNumbersOffset = vTable[2] {
                try reader.seek(by: optionalNumbersOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.optionalNumbers = try reader.readAndSeekUnionTypeArrayWithOptionals()
            } else {
                result.optionalNumbers = []
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public enum PersonId: UnionNode, Equatable, CycleAwareEquatable, CycleAwareHashable {

        case number(Float64), name(String)

        public var typeId: UInt64 {
            switch self {
                case .number: return 0
                case .name: return 1
            }
        }

        public static var byteWidth: ByteWidth { .eighth }

        public func cycleAwareEquality(other: Self, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            switch self {
                case .number(let selfValue):
                    if case .number(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .name(let selfValue):
                    if case .name(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
            }
        }

        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
                    switch self {
                case .number(let value):
                    value.hash(into: &hasher)
                case .name(let value):
                    value.hash(into: &hasher)
            }
        }

        public func apply(builder: Builder) throws -> AppliedUnionType {
            switch self {
                case .number(let value):
                    return .value(value: UInt64(value.bitPattern), id: 0)
                case .name(let value):
                    return .pointer(value: try builder.store(string: value), id: 1)
            }
        }

        public static func from<T: Reader>(typeId: UInt64, value: UInt64, reader: T, offset: UInt64) throws -> PersonId? {
            if typeId == 0 {
                return .number(Float64(bitPattern: value))
            }
            if typeId == 1 {
                try reader.seek(by: Int64(value))
                return try .name(reader.readAndSeekSting())
            }
            return nil
        }
    }

    public enum PersonId2: UnionNode, Equatable, CycleAwareEquatable, CycleAwareHashable {

        case number(Float64), name(String), root(Bool), int(Int32), array([Int32]), ref(Person11)

        public var typeId: UInt64 {
            switch self {
                case .number: return 0
                case .name: return 1
                case .root: return 2
                case .int: return 3
                case .array: return 4
                case .ref: return 5
            }
        }

        public static var byteWidth: ByteWidth { .half }

        public func cycleAwareEquality(other: Self, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            switch self {
                case .number(let selfValue):
                    if case .number(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .name(let selfValue):
                    if case .name(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .root(let selfValue):
                    if case .root(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .int(let selfValue):
                    if case .int(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .array(let selfValue):
                    if case .array(let otherValue) = other {
                        return selfValue == otherValue
                    }
                    return false
                case .ref(let selfValue):
                    if case .ref(let otherValue) = other {
                        return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)
                    }
                    return false
            }
        }

        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
                    switch self {
                case .number(let value):
                    value.hash(into: &hasher)
                case .name(let value):
                    value.hash(into: &hasher)
                case .root(let value):
                    value.hash(into: &hasher)
                case .int(let value):
                    value.hash(into: &hasher)
                case .array(let value):
                    value.hash(into: &hasher)
                case .ref(let selfRef):
                    selfRef.hash(into: &hasher, visited: &visited)
            }
        }

        public func apply(builder: Builder) throws -> AppliedUnionType {
            switch self {
                case .number(let value):
                    return .value(value: UInt64(value.bitPattern), id: 0)
                case .name(let value):
                    return .pointer(value: try builder.store(string: value), id: 1)
                case .root(let value):
                    return .value(value: value ? 1 : 0, id: 2)
                case .int(let value):
                    return .value(value: UInt64(UInt32(bitPattern: value)), id: 3)
                case .array(let value):
                    return .pointer(value: try builder.store(numbers: value), id: 4)
                case .ref(let value):
                    if let pointer = try builder.store(structNode: value) {
                        return .bidirPointer(value: pointer, id: 5)
                    } else {
                        return .reservedPointer(value: ObjectIdentifier(value), id: 5)
                    }
            }
        }

        public static func from<T: Reader>(typeId: UInt64, value: UInt64, reader: T, offset: UInt64) throws -> PersonId2? {
            if typeId == 0 {
                return .number(Float64(bitPattern: value))
            }
            if typeId == 1 {
                try reader.seek(by: Int64(value))
                return try .name(reader.readAndSeekSting())
            }
            if typeId == 2 {
                return .root(value == 1 ? true : false)
            }
            if typeId == 3 {
                return .int(Int32(bitPattern: UInt32(value)))
            }
            if typeId == 4 {
                try reader.seek(by: Int64(value))
                return try .array(reader.readAndSeekNumericArray())
            }
            if typeId == 5 {
                let bidirValue = value.fromZigZag
                if bidirValue < 0 { try reader.seek(to: offset) }
                try reader.seek(by: bidirValue)
                return try .ref(BuilderSamples.Person11.with(reader: reader, offset: reader.cursor))
            }
            return nil
        }
    }

    public final class Person11: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var personId: PersonId? = nil
        public var personIds: [PersonId] = []
        public var optionalPersonIds: [PersonId?] = []
        public var personId2: PersonId2? = nil
        public var personIds2: [PersonId2] = []

        public init() {}

        public init(personId: PersonId? = nil, personIds: [PersonId] = [], optionalPersonIds: [PersonId?] = [], personId2: PersonId2? = nil, personIds2: [PersonId2] = []) {
            self.personId = personId
            self.personIds = personIds
            self.optionalPersonIds = optionalPersonIds
            self.personId2 = personId2
            self.personIds2 = personIds2
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let personIdAppliedValue = try personId?.apply(builder: builder)
            let personIdsPointer = personIds.isEmpty ? nil : try builder.store(unionTypes: personIds)
            let optionalPersonIdsPointer = optionalPersonIds.isEmpty ? nil : try builder.storeWithOptionals(unionTypes: optionalPersonIds)
            let personId2AppliedValue = try personId2?.apply(builder: builder)
            let personIds2Pointer = personIds2.isEmpty ? nil : try builder.store(unionTypes: personIds2)

            let personIds2PointerCursor = try builder.storeForwardPointer(value: personIds2Pointer)
            let personId2PointerCursor = try personId2AppliedValue.map { try builder.store(unionType: $0) }
            let optionalPersonIdsPointerCursor = try builder.storeForwardPointer(value: optionalPersonIdsPointer)
            let personIdsPointerCursor = try builder.storeForwardPointer(value: personIdsPointer)
            let personIdPointerCursor = try personIdAppliedValue.map { try builder.store(unionType: $0) }

            return try builder.store(vTable: [personIdPointerCursor, personIdsPointerCursor, optionalPersonIdsPointerCursor, personId2PointerCursor, personIds2PointerCursor])

        }


        public func cycleAwareEquality(other: Person11, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)
            let isPersonidEqual: Bool
            if let personId = personId, let otherPersonid = other.personId {
                isPersonidEqual = personId.cycleAwareEquality(other: otherPersonid, visited: &visited)
            } else {
                isPersonidEqual = personId == other.personId
            }
            let isPersonid2Equal: Bool
            if let personId2 = personId2, let otherPersonid2 = other.personId2 {
                isPersonid2Equal = personId2.cycleAwareEquality(other: otherPersonid2, visited: &visited)
            } else {
                isPersonid2Equal = personId2 == other.personId2
            }

            return isPersonidEqual
                && self.personIds.cycleAwareEquality(other: other.personIds, visited: &visited)
                && self.optionalPersonIds.cycleAwareEquality(other: other.optionalPersonIds, visited: &visited)
                && isPersonid2Equal
                && self.personIds2.cycleAwareEquality(other: other.personIds2, visited: &visited)

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            personId?.hash(into: &hasher, visited: &visited)
            personIds.hash(into: &hasher, visited: &visited)
            optionalPersonIds.hash(into: &hasher, visited: &visited)
            personId2?.hash(into: &hasher, visited: &visited)
            personIds2.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person11 {
            var result: Person11
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let personIdOffset = vTable[0] {
                try reader.seek(by: personIdOffset)
                let typeId = try reader.readAndSeekLEB()
                let currentOffset = reader.cursor
                let value = try reader.readAndSeekLEB()
                result.personId = try PersonId.from(typeId: typeId, value: value, reader: reader, offset: currentOffset)
            } else {
                result.personId = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let personIdsOffset = vTable[1] {
                try reader.seek(by: personIdsOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.personIds = try reader.readAndSeekUnionTypeArray()
            } else {
                result.personIds = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 2, let optionalPersonIdsOffset = vTable[2] {
                try reader.seek(by: optionalPersonIdsOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.optionalPersonIds = try reader.readAndSeekUnionTypeArrayWithOptionals()
            } else {
                result.optionalPersonIds = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 3, let personId2Offset = vTable[3] {
                try reader.seek(by: personId2Offset)
                let typeId = try reader.readAndSeekLEB()
                let currentOffset = reader.cursor
                let value = try reader.readAndSeekLEB()
                result.personId2 = try PersonId2.from(typeId: typeId, value: value, reader: reader, offset: currentOffset)
            } else {
                result.personId2 = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 4, let personIds2Offset = vTable[4] {
                try reader.seek(by: personIds2Offset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.personIds2 = try reader.readAndSeekUnionTypeArray()
            } else {
                result.personIds2 = []
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class Person12: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var name: String! = "John Doe"
        public var active: Bool? = true
        public var gender: Gender! = .diverse
        public var genders1: [Gender] = []
        public var genders2: [Gender] = [.diverse, .female, .male]
        public var date: MyDate? = .millennium
        public var id: FoundationNode.UUID? = nil

        public init() {}

        public init(name: String = "John Doe", active: Bool? = true, gender: Gender = .diverse, genders1: [Gender] = [], genders2: [Gender] = [.diverse, .female, .male], date: MyDate? = .millennium, id: FoundationNode.UUID? = nil) {
            self.name = name
            self.active = active
            self.gender = gender
            self.genders1 = genders1
            self.genders2 = genders2
            self.date = date
            self.id = id
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let namePointer = try builder.store(string: name)
            let genders1Pointer = genders1.isEmpty ? nil : try builder.store(enums: genders1)
            let genders2Pointer = genders2.isEmpty ? nil : try builder.store(enums: genders2)
            let datePointer = try date.flatMap { try builder.store(structNode: $0) }
            let idPointer = try id.flatMap { try builder.store(structNode: $0) }

            var idPointerCursor: UInt64?
            if let id = id{
                if let pointer = idPointer {
                    idPointerCursor = try builder.storeBidirectionalPointer(value: pointer)
                } else {
                    idPointerCursor = try builder.reserveFieldPointer(for: id)
                }
            }
            var datePointerCursor: UInt64?
            if let date = date{
                if let pointer = datePointer {
                    datePointerCursor = try builder.storeBidirectionalPointer(value: pointer)
                } else {
                    datePointerCursor = try builder.reserveFieldPointer(for: date)
                }
            }
            let genders2PointerCursor = try builder.storeForwardPointer(value: genders2Pointer)
            let genders1PointerCursor = try builder.storeForwardPointer(value: genders1Pointer)
            let genderPointerCursor = try builder.store(enum: gender)
            let activeValueCursor = try active.map { try builder.store(number: $0 ? UInt8(1) : UInt8(0)) }
            let namePointerCursor = try builder.storeForwardPointer(value: namePointer)

            return try builder.store(vTable: [namePointerCursor, activeValueCursor, genderPointerCursor, genders1PointerCursor, genders2PointerCursor, datePointerCursor, idPointerCursor])

        }


        public func cycleAwareEquality(other: Person12, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)
            let isDateEqual: Bool
            if let date = date, let otherDate = other.date {
                isDateEqual = date.cycleAwareEquality(other: otherDate, visited: &visited)
            } else {
                isDateEqual = date == other.date
            }
            let isIdEqual: Bool
            if let id = id, let otherId = other.id {
                isIdEqual = id.cycleAwareEquality(other: otherId, visited: &visited)
            } else {
                isIdEqual = id == other.id
            }

            return self.name == other.name
                && self.active == other.active
                && self.gender == other.gender
                && self.genders1 == other.genders1
                && self.genders2 == other.genders2
                && isDateEqual
                && isIdEqual

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(name)
            hasher.combine(active)
            hasher.combine(gender)
            hasher.combine(genders1)
            hasher.combine(genders2)
            date?.hash(into: &hasher, visited: &visited)
            id?.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> Person12 {
            var result: Person12
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let nameOffset = vTable[0] {
                try reader.seek(by: nameOffset)
                let stringPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(stringPointer))
                result.name = try reader.readSting()
            } else {
                throw ReaderError.requiredFieldIsMissing
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let activeOffset = vTable[1] {
                try reader.seek(by: activeOffset)
                result.active = try reader.readAndSeekBool()
            } else {
                result.active = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 2, let genderOffset = vTable[2] {
                try reader.seek(by: genderOffset)
                let genderValue: UInt8 = try reader.readAndSeekNumeric()
                result.gender = try Gender.tryFrom(value: UInt64(genderValue))
            } else {
                throw ReaderError.requiredFieldIsMissing
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 3, let genders1Offset = vTable[3] {
                try reader.seek(by: genders1Offset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.genders1 = try reader.readAndSeekEnumArray()
            } else {
                result.genders1 = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 4, let genders2Offset = vTable[4] {
                try reader.seek(by: genders2Offset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.genders2 = try reader.readAndSeekEnumArray()
            } else {
                result.genders2 = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 5, let dateOffset = vTable[5] {
                try reader.seek(by: dateOffset)
                let _pointerOffset = reader.cursor
                let datePointer = try reader.readAndSeekSignedLEB()
                if datePointer < 0 { try reader.seek(to: _pointerOffset) }
                result.date = try MyDate.with(reader: reader, offset:  UInt64(Int64(reader.cursor) + datePointer))
            } else {
                result.date = nil
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 6, let idOffset = vTable[6] {
                try reader.seek(by: idOffset)
                let _pointerOffset = reader.cursor
                let idPointer = try reader.readAndSeekSignedLEB()
                if idPointer < 0 { try reader.seek(to: _pointerOffset) }
                result.id = try FoundationNode.UUID.with(reader: reader, offset:  UInt64(Int64(reader.cursor) + idPointer))
            } else {
                result.id = nil
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class StringDict1: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var keys: [String] = []
        public var values: [Person1] = []

        public init() {}

        public init(keys: [String], values: [Person1]) {
            self.keys = keys
            self.values = values
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let keysPointer = try builder.store(strings: keys)
            let valuesPointer = try builder.store(structNodes: values)

            _ = try builder.storeForwardPointer(value: valuesPointer)
            _ = try builder.storeForwardPointer(value: keysPointer)

            return builder.cursor

        }


        public func cycleAwareEquality(other: StringDict1, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.keys == other.keys
                && self.values.cycleAwareEquality(other: other.values, visited: &visited)

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(keys)
            values.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> StringDict1 {
            var result: StringDict1
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            do {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.keys = try reader.readAndSeekStringArray()
                try reader.seek(to: currentCursor)
            }
            do {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.values = try reader.readAndSeekStructArray()
                try reader.seek(to: currentCursor)
            }

            return result
        }

    }

    public final class StringDict2: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var keys: [String] = []
        public var values: [Person1] = []

        public init() {}

        public init(keys: [String] = [], values: [Person1] = []) {
            self.keys = keys
            self.values = values
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let keysPointer = keys.isEmpty ? nil : try builder.store(strings: keys)
            let valuesPointer = values.isEmpty ? nil : try builder.store(structNodes: values)

            _ = try builder.storeForwardPointer(value: valuesPointer)
            _ = try builder.storeForwardPointer(value: keysPointer)

            return try builder.store(inline: [keys.isEmpty == false, values.isEmpty == false].bitSet)

        }


        public func cycleAwareEquality(other: StringDict2, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.keys == other.keys
                && self.values.cycleAwareEquality(other: other.values, visited: &visited)

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(keys)
            values.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> StringDict2 {
            var result: StringDict2
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let optionalFields = try reader.readAndSeekBoolArrayWithLength(length: 2)
            if optionalFields[0] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.keys = try reader.readAndSeekStringArray()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[1] {
                let arrayPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(arrayPointer))
                result.values = try reader.readAndSeekStructArray()
                try reader.seek(to: currentCursor)
            }

            return result
        }

    }

    public final class StringDict3: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var keys: [String] = []
        public var values: [Person1] = []

        public init() {}

        public init(keys: [String] = [], values: [Person1] = []) {
            self.keys = keys
            self.values = values
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let keysPointer = keys.isEmpty ? nil : try builder.store(strings: keys)
            let valuesPointer = values.isEmpty ? nil : try builder.store(structNodes: values)

            let valuesPointerCursor = try builder.storeForwardPointer(value: valuesPointer)
            let keysPointerCursor = try builder.storeForwardPointer(value: keysPointer)

            return try builder.store(vTable: [keysPointerCursor, valuesPointerCursor])

        }


        public func cycleAwareEquality(other: StringDict3, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.keys == other.keys
                && self.values.cycleAwareEquality(other: other.values, visited: &visited)

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(keys)
            values.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> StringDict3 {
            var result: StringDict3
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let keysOffset = vTable[0] {
                try reader.seek(by: keysOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.keys = try reader.readAndSeekStringArray()
            } else {
                result.keys = []
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let valuesOffset = vTable[1] {
                try reader.seek(by: valuesOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.values = try reader.readAndSeekStructArray()
            } else {
                result.values = []
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class StringDict4: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var keys: [String] = []
        public var values: [Person1] = []

        public init() {}

        public init(keys: [String], values: [Person1]) {
            self.keys = keys
            self.values = values
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let keysPointer = try builder.store(strings: keys)
            let valuesPointer = try builder.store(structNodes: values)

            let valuesPointerCursor = try builder.storeForwardPointer(value: valuesPointer)
            let keysPointerCursor = try builder.storeForwardPointer(value: keysPointer)

            return try builder.store(vTable: [keysPointerCursor, valuesPointerCursor])

        }


        public func cycleAwareEquality(other: StringDict4, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.keys == other.keys
                && self.values.cycleAwareEquality(other: other.values, visited: &visited)

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(keys)
            values.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> StringDict4 {
            var result: StringDict4
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekVTable()
            let vTableStartOffest = reader.cursor
            if vTable.count > 0, let keysOffset = vTable[0] {
                try reader.seek(by: keysOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.keys = try reader.readAndSeekStringArray()
            } else {
                throw ReaderError.requiredFieldIsMissing
            }
            try reader.seek(to: vTableStartOffest)
            if vTable.count > 1, let valuesOffset = vTable[1] {
                try reader.seek(by: valuesOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.values = try reader.readAndSeekStructArray()
            } else {
                throw ReaderError.requiredFieldIsMissing
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class StringDict5: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var keys: [String] = []
        public var values: [Person1] = []

        public init() {}

        public init(keys: [String], values: [Person1]) {
            self.keys = keys
            self.values = values
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let keysPointer = try builder.store(strings: keys)
            let valuesPointer = try builder.store(structNodes: values)

            let valuesPointerCursor = try builder.storeForwardPointer(value: valuesPointer)
            let keysPointerCursor = try builder.storeForwardPointer(value: keysPointer)

            return try builder.storeSparse(vTable: [keysPointerCursor, valuesPointerCursor])

        }


        public func cycleAwareEquality(other: StringDict5, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.keys == other.keys
                && self.values.cycleAwareEquality(other: other.values, visited: &visited)

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(keys)
            values.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> StringDict5 {
            var result: StringDict5
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekSparseVTable()
            let vTableStartOffest = reader.cursor
            if let keysOffset = vTable[0] {
                try reader.seek(by: keysOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.keys = try reader.readAndSeekStringArray()
            } else {
                throw ReaderError.requiredFieldIsMissing
            }
            try reader.seek(to: vTableStartOffest)
            if let valuesOffset = vTable[1] {
                try reader.seek(by: valuesOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.values = try reader.readAndSeekStructArray()
            } else {
                throw ReaderError.requiredFieldIsMissing
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

    public final class StringDict6: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var keys: [String] = []
        public var values: [Person1] = []

        public init() {}

        public init(keys: [String] = [], values: [Person1] = []) {
            self.keys = keys
            self.values = values
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let keysPointer = keys.isEmpty ? nil : try builder.store(strings: keys)
            let valuesPointer = values.isEmpty ? nil : try builder.store(structNodes: values)

            let valuesPointerCursor = try builder.storeForwardPointer(value: valuesPointer)
            let keysPointerCursor = try builder.storeForwardPointer(value: keysPointer)

            return try builder.storeSparse(vTable: [keysPointerCursor, valuesPointerCursor])

        }


        public func cycleAwareEquality(other: StringDict6, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.keys == other.keys
                && self.values.cycleAwareEquality(other: other.values, visited: &visited)

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(keys)
            values.hash(into: &hasher, visited: &visited)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> StringDict6 {
            var result: StringDict6
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let vTable = try reader.readAndSeekSparseVTable()
            let vTableStartOffest = reader.cursor
            if let keysOffset = vTable[0] {
                try reader.seek(by: keysOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.keys = try reader.readAndSeekStringArray()
            } else {
                result.keys = []
            }
            try reader.seek(to: vTableStartOffest)
            if let valuesOffset = vTable[1] {
                try reader.seek(by: valuesOffset)
                let arrayPointer = try reader.readAndSeekLEB()
                try reader.seek(by: Int64(arrayPointer))
                result.values = try reader.readAndSeekStructArray()
            } else {
                result.values = []
            }
            try reader.seek(to: vTableStartOffest)

            return result
        }

    }

}