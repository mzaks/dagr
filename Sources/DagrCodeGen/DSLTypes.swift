//
//  DSLTypes.swift
//
//
//  Created by Maxim Zaks on 28.10.22.
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

public protocol NodeType: Codable {
    var name: String {get}
}

@resultBuilder
public struct NodeTypeBuilder {
    public static func buildBlock(_ components: NodeType...) -> [NodeType] {
        return components
    }
}


public struct Node: NodeType, Codable {
    public let name: String
    public let frozen: Bool
    public let sparse: Bool
    public let fields: [Field]

    public init(_ name: String, @FieldBuilder fields: () -> [Field]) {
        self.name = name
        self.frozen = false
        self.sparse = false
        self.fields = fields()
    }

    public init(_ name: String, frozen: Bool, @FieldBuilder fields: () -> [Field]) {
        self.name = name
        self.frozen = frozen
        self.sparse = false
        self.fields = fields()
    }

    public init(_ name: String, sparse: Bool, @FieldBuilder fields: () -> [Field]) {
        self.name = name
        self.frozen = false
        self.sparse = sparse
        self.fields = fields()
    }
}

extension Node {
    enum NodeError: Error, LocalizedError, Equatable {
        case indexIsAlreadyTaken(index: UInt, name1: String, name2: String)
        case unexpectedIndexStep(index: UInt, prevIndex: Int, fieldName: String)

        var errorDescription: String? {
            switch self {
            case .indexIsAlreadyTaken(let index, let name1, let name2):
                return "Index: \(index) is taken by fields: \(name1) and \(name2)"
            case .unexpectedIndexStep(index: let index, prevIndex: let prevIndex, fieldName: let fieldName):
                return "Unexpected step from index \(prevIndex) to \(index) named \(fieldName)"
            }
        }
    }
    var collidingFieldNames: Set<String> {
        var visitedFieldNames = Set<String>()
        var result = Set<String>()
        for field in fields {
            if visitedFieldNames.contains(field.name) {
                result.insert(field.name)
            } else {
                visitedFieldNames.insert(field.name)
            }
        }
        return result
    }

    var fieldsWithInvalidOptions: Set<String> {
        var result = Set<String>()
        for field in fields {
            if field.fieldOptions.invalid {
                result.insert(field.name)
            }
        }
        return result
    }

    var indexedFields: [UInt: Field] {
        get throws {
            var result = [UInt: Field]()
            func addField(field: Field) throws {
                let index = field.index!
                guard result[index] == nil else {
                    throw NodeError.indexIsAlreadyTaken(index: index, name1: result[index]!.name, name2: field.name)
                }
                result[index] = field
            }
            for (index, field) in fields.enumerated() {
                if field.index != nil {
                    try addField(field: field)
                } else {
                    try addField(field: Field(field.name, type: field.type, fieldOptions: field.fieldOptions, index: UInt(index)))
                }
            }

            var prevIndex: Int = -1
            for index in result.keys.sorted() {
                if index == 0 {
                    prevIndex = 0
                    continue
                }
                if Int(index) - prevIndex != 1 {
                    throw NodeError.unexpectedIndexStep(index: index, prevIndex: prevIndex, fieldName: result[index]!.name)
                }
                prevIndex = Int(index)
            }
            return result
        }
    }
}

public struct Enum: NodeType {
    public let name: String
    public let cases: [UInt: String]
    public let capacity: UInt16
    public let asBitSet: Bool

    public init(_ name: String, cases: [UInt: String], capacity: UInt16? = nil, asBitSet: Bool = false) {
        self.name = name
        self.cases = cases
        if let capacity {
            self.capacity = capacity
        } else {
            if cases.count <= 2 {
                self.capacity = 2
            } else if cases.count <= 4 {
                self.capacity = 4
            } else if cases.count <= 16 {
                self.capacity = 16
            } else if cases.count <= UInt8.max {
                self.capacity = UInt16(UInt8.max)
            } else {
                self.capacity = UInt16.max
            }
        }
        self.asBitSet = asBitSet
    }

    public init(_ name: String, _ sortedCases: [String], capacity: UInt16? = nil, asBitSet: Bool = false) {
        var cases = [UInt: String]()
        for currentCase in sortedCases.enumerated() {
            cases[UInt(currentCase.offset)] = currentCase.element
        }
        self.init(name, cases: cases, capacity: capacity, asBitSet: asBitSet)
    }
}

extension Enum {
    var collidingCaseNames: Set<String> {
        var visited = Set<String>()
        var result = Set<String>()
        for caseName in cases.values {
            if visited.contains(caseName) {
                result.insert(caseName)
            } else {
                visited.insert(caseName)
            }
        }
        return result
    }

    var isOverCapaicty: Bool {
        (cases.keys.max() ?? 0) >= capacity
    }

    func compatible(with prev: Enum, strict: Bool) throws {
        guard self.asBitSet == prev.asBitSet else {
            throw CompatibilityError.changedBitsetProperty(enumName: self.name)
        }

        guard self.capacity == prev.capacity else {
            throw CompatibilityError.changedCapacity(name: self.name)
        }

        if strict {
            if cases.keys != prev.cases.keys {
                throw CompatibilityError.changedStrictEnumUsage(name: self.name)
            }
        }

        for index in prev.cases.keys {
            let prevCaseName = prev.cases[index]!
            let currentCaseName = self.cases[index]
            guard currentCaseName == prevCaseName else {
                throw CompatibilityError.changedCaseName(enumName: name, index: index, prevCaseName: prevCaseName, currentCaseName: currentCaseName)
            }
        }
    }
}

public struct TypePair: Codable {
    let name: String
    let type: EntryType
}

public struct UnionType: NodeType, Codable {
    public let name: String
    public let types: [TypePair]
    public let capacity: UInt16

    public init(_ name: String, types: [(String, EntryType)], capacity: UInt16? = nil) {
        self.name = name
        self.types = types.map{ TypePair(name: $0.0, type: $0.1)}
        if let capacity {
            self.capacity = capacity
        } else {
            if types.count <= 2 {
                self.capacity = 2
            } else if types.count <= 4 {
                self.capacity = 4
            } else if types.count <= 16 {
                self.capacity = 16
            } else if types.count <= UInt8.max {
                self.capacity = UInt16(UInt8.max)
            } else {
                self.capacity = UInt16.max
            }
        }

    }
}

extension UnionType {
    var collidingTypeNames: Set<String> {
        var visited = Set<String>()
        var result = Set<String>()
        for type in types {
            if visited.contains(type.name) {
                result.insert(type.name)
            } else {
                visited.insert(type.name)
            }
        }
        return result
    }

    var isOverCapaicty: Bool {
        types.count > capacity
    }

    func compatible(with prev: UnionType, strict: Bool, selfLookup: Dictionary<String, NodeType>, otherLookup: Dictionary<String, NodeType>, visited: inout Set<String>) throws {
        guard self.capacity == prev.capacity else {
            throw CompatibilityError.changedCapacity(name: self.name)
        }
        guard prev.types.count <= self.types.count else {
            throw CompatibilityError.removedTypeCase(unionTypeName: name, prevCount: prev.types.count, currentCount: types.count)
        }
        if strict {
            if types.count != prev.types.count {
                throw CompatibilityError.changedStrictUnionTypeUsage(name: name)
            }
        }
        for (index, pair) in prev.types.enumerated() {
            let prevType = pair.type
            let currentType = self.types[index].type
            guard try currentType.compatible(with: prevType, strict: true, selfLookup: selfLookup, otherLookup: otherLookup, visited: &visited) else {
                throw CompatibilityError.changedUnitType(unionTypeName: name, index: UInt(index))
            }
        }
    }
}

public indirect enum EntryType: Equatable, Hashable, Codable {
    case u8, u16, u32, u64,
         i8, i16, i32, i64,
         f32, f64,
         bool,
         utf8, data,
         ref(_ name: String),
         array(_ arrayType: EntryType),
         arrayWithOptionals(_ arrayType: EntryType)

    public var array: EntryType {
        .array(self)
    }

    public var arrayWithOptionals: EntryType {
        .arrayWithOptionals(self)
    }

    func strucutrallySame(as other: EntryType) -> Bool {
        switch self {
        case .u8:
            return other == .u8
        case .u16:
            return other == .u16
        case .u32:
            return other == .u32
        case .u64:
            return other == .u64
        case .i8:
            return other == .i8
        case .i16:
            return other == .i16
        case .i32:
            return other == .i32
        case .i64:
            return other == .i64
        case .f32:
            return other == .f32
        case .f64:
            return other == .f64
        case .bool:
            return other == .bool
        case .utf8:
            return other == .utf8
        case .data:
            return other == .data
        case .ref:
            if case .ref(_) = other {
                return true
            }
            return false
        case .array(let entryType):
            if case let .array(otherEntry) = other {
                return entryType.strucutrallySame(as: otherEntry)
            }
            return false
        case .arrayWithOptionals(let entryType):
            if case let .arrayWithOptionals(otherEntry) = other {
                return entryType.strucutrallySame(as: otherEntry)
            }
            return false
        }
    }

    func isValidReference(_ knownNames: Dictionary<String, NodeType>.Keys) -> Bool {
        switch self {
        case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
            return true
        case .ref(let name):
            return knownNames.contains(name)
        case .array(let entryType):
            return entryType.isValidReference(knownNames)
        case .arrayWithOptionals(let entryType):
            return entryType.isValidReference(knownNames)
        }
    }

    func validate(lookup: Dictionary<String, NodeType>, visited: inout Set<EntryType>) throws {
        guard visited.contains(self) == false else {
            return
        }
        visited.insert(self)
        switch self {
        case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
            return
        case .ref(let name):
            guard let type = lookup[name] else {
                throw ValidationError.unresolvedReferences(names: [name])
            }
            if let s = type as? Node {
                let invalidOptionsFieldNames = s.fieldsWithInvalidOptions.sorted()
                guard invalidOptionsFieldNames.isEmpty else {
                    throw ValidationError.fieldsWithInvalidOptions(nodeName: name, fieldNames: invalidOptionsFieldNames)
                }
                let collidingFieldNames = s.collidingFieldNames.sorted()
                guard collidingFieldNames.isEmpty else {
                    throw ValidationError.collidingFieldNames(nodeName: name, fieldNames: collidingFieldNames)
                }
                do {
                    for f in try s.indexedFields.values {
                        try f.type.validate(lookup: lookup, visited: &visited)
                    }
                } catch {
                    guard let error = error as? Node.NodeError else {
                        throw error
                    }
                    throw ValidationError.nodeError(nodeName: name, error: error)
                }

            } else if let e = type as? Enum {
                guard e.isOverCapaicty == false else {
                    throw ValidationError.enumOvercapacity(enumName: name)
                }

                let collidingCaseNames = e.collidingCaseNames.sorted()
                guard collidingCaseNames.isEmpty else {
                    throw ValidationError.enumCollidingCaseNames(enumName: name, caseNames: collidingCaseNames)
                }
            } else if let u = type as? UnionType {
                guard u.isOverCapaicty == false else {
                    throw ValidationError.unionTypeOvercapacity(unionTypeName: name)
                }
                let collidingTypeNames = u.collidingTypeNames.sorted()
                guard collidingTypeNames.isEmpty else {
                    throw ValidationError.unionTypeCollidingNames(unionTypeName: name, typeNames: collidingTypeNames)
                }

                for t in u.types.map({ $0.type }) {
                    try t.validate(lookup: lookup, visited: &visited)
                }
            }
        case .array(let entryType):
            return try entryType.validate(lookup: lookup, visited: &visited)
        case .arrayWithOptionals(let entryType):
            return try entryType.validate(lookup: lookup, visited: &visited)
        }
    }

    func compatible(with prev: EntryType, strict: Bool, selfLookup: Dictionary<String, NodeType>, otherLookup: Dictionary<String, NodeType>, visited: inout Set<String>) throws -> Bool {

        guard self.strucutrallySame(as: prev) else {
            return false
        }

        switch self {
        case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
            return true
        case .ref(let name):
            guard case let .ref(prevName) = prev else {
                return false
            }
            guard let selfType = selfLookup[name] else { return false }
            guard let prevType = otherLookup[prevName] else { return false }
            guard type(of: selfType) == type(of: prevType) else {
                throw CompatibilityError.typeWasChanged(typeName: selfType.name, prevType: "\(type(of: prevType))", currentType: "\(type(of: selfType))")
            }
            if let current = selfType as? Node, let prev = prevType as? Node {
                let prevIndexedFields = try prev.indexedFields
                let currentIndexedFields = try current.indexedFields
                for index in prevIndexedFields.keys {
                    guard let prevField = prevIndexedFields[index], let currentField = currentIndexedFields[index] else {
                        throw CompatibilityError.removedField(nodeName: selfType.name, fieldName: prevIndexedFields[index]!.name)
                    }
                    let fieldPath = "\(current.name)::\(currentField.name)"
                    if visited.contains(fieldPath) {
                        continue
                    } else {
                        visited.insert(fieldPath)
                    }

                    let isRequired = currentField.fieldOptions.contains(.required)

                    guard try currentField.type.compatible(with: prevField.type, strict: isRequired, selfLookup: selfLookup, otherLookup: otherLookup, visited: &visited) else {
                        throw CompatibilityError.changedFieldType(nodeName: selfType.name, fieldName: prevField.name)
                    }
                    guard currentField.fieldOptions.compatible(with: prevField.fieldOptions) else {
                        throw CompatibilityError.incompatibleFieldOptions(nodeName: selfType.name, fieldName: prevField.name)
                    }
                }
                for index in currentIndexedFields.keys {
                    if let field = currentIndexedFields[index], prevIndexedFields[index] == nil {
                        guard currentIndexedFields[index]!.fieldOptions.contains(.required) == false else {
                            throw CompatibilityError.newFieldShouldNotBeRequired(structName: selfType.name, fieldName: field.name)
                        }
                    }
                }
            } else if let current = selfType as? Enum, let prev = prevType as? Enum {
                try current.compatible(with: prev, strict: strict)
            } else if let current = selfType as? UnionType, let prev = prevType as? UnionType {
                try current.compatible(with: prev, strict: strict, selfLookup: selfLookup, otherLookup: otherLookup, visited: &visited)
            }
            return true
        case .array(let entryType):
            guard case let .array(prevEntry) = prev else {
                return false
            }
            return try entryType.compatible(with: prevEntry, strict: true, selfLookup: selfLookup, otherLookup: otherLookup, visited: &visited)
        case .arrayWithOptionals(let entryType):
            guard case let .arrayWithOptionals(prevEntry) = prev else {
                return false
            }
            return try entryType.compatible(with: prevEntry, strict: false, selfLookup: selfLookup, otherLookup: otherLookup, visited: &visited)
        }
    }

    var typeName: String {
        switch self {
        case .u8:
            return "u8"
        case .u16:
            return "u16"
        case .u32:
            return "u32"
        case .u64:
            return "u64"
        case .i8:
            return "i8"
        case .i16:
            return "i16"
        case .i32:
            return "i32"
        case .i64:
            return "i64"
        case .f32:
            return "f32"
        case .f64:
            return "f64"
        case .bool:
            return "bool"
        case .utf8:
            return "utf8"
        case .data:
            return "data"
        case .ref(let name):
            return name
        case .array(let entryType):
            return "[\(entryType.typeName)]"
        case .arrayWithOptionals(let entryType):
            return "[\(entryType.typeName)?]"
        }
    }
}

public struct FieldOptions: OptionSet, Equatable, Codable, Sendable {
    public let rawValue: Int
    public static let required = FieldOptions(rawValue: 1 << 0)
    public static let deprecated = FieldOptions(rawValue: 1 << 1)
    public static let key = FieldOptions(rawValue: 1 << 2)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    var invalid: Bool {
        self.contains(.deprecated) && isRequired
    }

    var isRequired: Bool {
        self.contains(.required) || self.contains(.key)
    }

    func compatible(with prev: FieldOptions) -> Bool {
        if self.contains(.required) {
            guard prev.contains(.required) else {
                return false
            }
        }
        if prev.contains(.required) {
            guard self.contains(.required) else {
                return false
            }
        }

        if self.contains(.key) {
            guard prev.contains(.key) else {
                return false
            }
        }
        if prev.contains(.key) {
            guard self.contains(.key) else {
                return false
            }
        }

        if prev.contains(.deprecated) {
            guard self.contains(.deprecated) else {
                return false
            }
        }
        return true
    }
}

public struct Field: Equatable, Codable {

    let name: String
    public let type: EntryType
    public let fieldOptions: FieldOptions
    public let index: UInt?

    public init(_ name: String, type: EntryType, fieldOptions: FieldOptions = [], index: UInt? = nil) {
        self.name = name
        self.type = type
        self.fieldOptions = fieldOptions
        self.index = index
    }
}

@resultBuilder
public struct FieldBuilder {
    public static func buildBlock(_ components: Field...) -> [Field] {
        return components
    }
}

public struct DataGraph: Codable {
    let name: String
    let rootType: EntryType
    let nodeTypes: [NodeType]

    public init(_ name: String, rootType: EntryType, @NodeTypeBuilder types: () -> [NodeType]) {
        self.name = name
        self.rootType = rootType
        self.nodeTypes = types()
    }

    enum CodingKeys: String, CodingKey {
        case name
        case rootType
        case nodeTypes
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(rootType, forKey: .rootType)
        var nodeTypesC = c.nestedUnkeyedContainer(forKey: .nodeTypes)
        for type in nodeTypes {
            if let type = type as? Node {
                try nodeTypesC.encode(type)
            } else if let type = type as? Enum {
                try nodeTypesC.encode(type)
            } else if let type = type as? UnionType {
                try nodeTypesC.encode(type)
            }
        }
    }


    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        rootType = try c.decode(EntryType.self, forKey: .rootType)
        var nodeTypes = [NodeType]()
        var nodeTypesC = try c.nestedUnkeyedContainer(forKey: .nodeTypes)
        while !nodeTypesC.isAtEnd {
            if let s = try? nodeTypesC.decode(Node.self) {
                nodeTypes.append(s)
            } else if let e = try? nodeTypesC.decode(Enum.self) {
                nodeTypes.append(e)
            } else if let u = try? nodeTypesC.decode(UnionType.self) {
                nodeTypes.append(u)
            }
        }
        self.nodeTypes = nodeTypes
    }
}

enum ValidationError: Error, Equatable {
    case graphNameIsNotSet
    case rootTypeIsNotValidReference
    case dupplicateNodes(names: [String])
    case unresolvedReferences(names: [String])
    case fieldsWithInvalidOptions(nodeName: String, fieldNames: [String])
    case nodeError(nodeName: String, error: Node.NodeError)
    case collidingFieldNames(nodeName: String, fieldNames: [String])
    case enumOvercapacity(enumName: String)
    case enumCollidingCaseNames(enumName: String, caseNames: [String])
    case unionTypeOvercapacity(unionTypeName: String)
    case unionTypeCollidingNames(unionTypeName: String, typeNames: [String])
}

extension DataGraph {

    var duplicateNodeTypes: [String: [NodeType]] {
        Dictionary(grouping: self.nodeTypes) { $0.name }.filter { $0.value.count > 1 }
    }

    var unresolvedTypeReferences: Set<String> {
        let lookupTable = nodeTypeLookupTable.keys
        var result = Set<String>()
        for nodeType in nodeTypes {
            if let s = nodeType as? Node {
                for field in s.fields {
                    if field.type.isValidReference(lookupTable) == false {
                        result.insert(field.type.typeName)
                    }
                }
            } else if let u = nodeType as? UnionType {
                for type in u.types {
                    if type.type.isValidReference(lookupTable) == false {
                        result.insert(type.type.typeName)
                    }
                }
            }
        }
        return result
    }

    var nodeTypeLookupTable: [String: NodeType] {
        Dictionary(grouping: self.nodeTypes) { $0.name }.mapValues{ $0[0] }
    }

    func validate() throws {
        guard name.isEmpty == false else {
            throw ValidationError.graphNameIsNotSet
        }
        let lookup = nodeTypeLookupTable
        guard rootType.isValidReference(lookup.keys) else {
            throw ValidationError.rootTypeIsNotValidReference
        }

        do {
            let names = duplicateNodeTypes.keys.sorted()
            guard names.isEmpty else {
                throw ValidationError.dupplicateNodes(names: names)
            }
        }

        do {
            let names = unresolvedTypeReferences.sorted()
            guard names.isEmpty else {
                throw ValidationError.unresolvedReferences(names: names)
            }
        }
        var visited = Set<EntryType>()
        try rootType.validate(lookup: lookup, visited: &visited)
    }

    func checkCompatiblityWith(previous: DataGraph) throws {
        let lookup = self.nodeTypeLookupTable
        let prevLookup = previous.nodeTypeLookupTable
        var visited = Set<String>()

        guard try rootType.compatible(with: previous.rootType, strict: true, selfLookup: lookup, otherLookup: prevLookup, visited: &visited) else {
            throw CompatibilityError.differentRootTypes
        }
    }
}

public enum CompatibilityError: Error, Equatable {
    case differentRootTypes
    case removedField(nodeName: String, fieldName: String)
    case changedFieldType(nodeName: String, fieldName: String)
    case typeWasChanged(typeName: String, prevType: String, currentType: String)
    case incompatibleFieldOptions(nodeName: String, fieldName: String)
    case changedBitsetProperty(enumName: String)
    case changedCapacity(name: String)
    case changedStrictEnumUsage(name: String)
    case changedCaseName(enumName: String, index: UInt, prevCaseName: String, currentCaseName: String?)
    case changedUnitType(unionTypeName: String, index: UInt)
    case removedTypeCase(unionTypeName: String, prevCount: Int, currentCount: Int)
    case changedStrictUnionTypeUsage(name: String)
    case newFieldShouldNotBeRequired(structName: String, fieldName: String)
}

infix operator ++ : AdditionPrecedence

public func ++(name: String, type: EntryType) -> Field {
    Field(name, type: type)
}

public func ++(field: Field, index: UInt) -> Field {
    Field(field.name, type: field.type, fieldOptions: field.fieldOptions, index: index)
}

public func ++(field: Field, options: FieldOptions) -> Field {
    Field(field.name, type: field.type, fieldOptions: options, index: field.index)
}
