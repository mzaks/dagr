//
//  Generator.swift
//  
//
//  Created by Maxim Zaks on 28.10.22.
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

public enum GeneratorError: Error {
    case couldNotEnumarateFolder
}

public struct GenerationProtocol: Codable {
    let graph: DataGraph
    let timestamp: String
    let author: String

    init(graph: DataGraph) {
        self.graph = graph
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .long
        self.timestamp = df.string(from: Date())
        self.author = NSFullUserName()
    }
}

public struct Indentation: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    let string: String
    let depth: UInt

    public init(stringLiteral value: String) {
        string = value
        depth = 0
    }

    public init(string: String, depth: UInt) {
        self.string = string
        self.depth = depth
    }
}

public func +(indentation: Indentation, value: Int) -> Indentation {
    Indentation(string: indentation.string, depth: indentation.depth + UInt(value))
}

public func generate(graph:DataGraph, path: URL, with indentation: Indentation = "    ", fileNameSuffix: String = "") throws {
    try graph.validate()

    try validateCompatibility(graph: graph, path: path)

    let graphName = graph.name
    let lookup = graph.nodeTypeLookupTableWithImports
    let nodeNameResolution = graph.importedNodeNameResolutionTable
    var types = [String]()
    for type in graph.nodeTypes {
        if let e = type as? Enum {
            types.append(generate(enum: e, with: indentation + 1))
        } else if let u = type as? UnionType {
            types.append(generate(unionType: u, with: indentation + 1, lookup: lookup, nodeNameResolution: nodeNameResolution, graphName: graphName))
        } else if let s = type as? Node {
            types.append(generate(struct: s, with: indentation + 1, lookup: lookup, nodeNameResolution: nodeNameResolution))
        } else {
            fatalError("Unexpected type")
        }
    }
    func generateEncodeMethod(root: EntryType, indentation: Indentation, lookup: [String: NodeType]) -> String {
        var result = [String]()
        result.append("public static func encode(root: \(typeName(entryType: root, nodeNameResolution: nodeNameResolution))) throws -> Data {".expressionIndent(with: indentation))
        result.append("let builder = DataBuilder()".expressionIndent(with: indentation + 1))
        var withOptionals = true
        switch root {
        case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
            result.append("_ = try builder.store(number: root)".expressionIndent(with: indentation + 1))
        case .bool:
            result.append("_ = try builder.store(number: root ? UInt8(1): UInt8(0))".expressionIndent(with: indentation + 1))
        case .utf8:
            result.append("_ = try builder.store(string: root)".expressionIndent(with: indentation + 1))
        case .data:
            result.append("_ = try builder.store(data: root)".expressionIndent(with: indentation + 1))
        case .ref(let typeName):
            let type = lookup[typeName]!
            if type is Node {
                result.append("guard let rootPointer = try builder.store(structNode: root) else { throw BuilderError.couldNotStoreRoot }".expressionIndent(with: indentation + 1))
                result.append("_ = try builder.storeForwardPointer(value: rootPointer)".expressionIndent(with: indentation + 1))
            } else if type is Enum {
                result.append("_ = try builder.store(enum: root)".expressionIndent(with: indentation + 1))
            } else if type is UnionType {
                result.append("let unionType = try root.apply(builder: builder)".expressionIndent(with: indentation + 1))
                result.append("_ = try builder.store(unionType: unionType)".expressionIndent(with: indentation + 1))
            } else {
                fatalError("Unexpected type \(type)")
            }
        case .array(let arrayType):
            withOptionals = false
            fallthrough
        case .arrayWithOptionals(let arrayType):
            let suffix = withOptionals ? "WithOptionals" : ""
            switch arrayType {
            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
                result.append("_ = try builder.store\(suffix)(numbers: root)".expressionIndent(with: indentation + 1))
            case .bool:
                result.append("_ = try builder.store\(suffix)(bools: root)".expressionIndent(with: indentation + 1))
            case .utf8:
                result.append("_ = try builder.store(strings: root)".expressionIndent(with: indentation + 1))
            case .data:
                result.append("_ = try builder.store(datas: root)".expressionIndent(with: indentation + 1))
            case .ref(let typeName):
                let type = lookup[typeName]!
                if type is Node {
                    result.append("_ = try builder.store(structNodes: root) else { throw BuilderError.couldNotStoreRoot }".expressionIndent(with: indentation + 1))
                } else if type is Enum {
                    result.append("_ = try builder.store\(suffix)(enums: root)".expressionIndent(with: indentation + 1))
                } else if type is UnionType {
                    result.append("_ = try builder.store\(suffix)(unionTypes: root)".expressionIndent(with: indentation + 1))
                } else {
                    fatalError("Unexpected type \(type)")
                }
            case .array, .arrayWithOptionals:
                fatalError("Does not support arrays")
            }
        }

        result.append("return builder.makeData".expressionIndent(with: indentation + 1))
        result.append("}".expressionIndent(with: indentation))
        return result.joined(separator: "\n")
    }
    func generateDecodeMethod(root: EntryType, indentation: Indentation, lookup: [String: NodeType]) -> String {
        var result = [String]()
        result.append("public static func decode(data: Data) throws -> \(typeName(entryType: root, nodeNameResolution: nodeNameResolution)) {".expressionIndent(with: indentation))
        result.append("let reader = DataReader(data: data)".expressionIndent(with: indentation + 1))

        var withOptionals = true
        switch root {
        case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
            result.append("return try reader.readAndSeekNumeric()".expressionIndent(with: indentation + 1))
        case .bool:
            result.append("return try reader.readBool()".expressionIndent(with: indentation + 1))
        case .utf8:
            result.append("return try reader.readAndSeekSting()".expressionIndent(with: indentation + 1))
        case .data:
            result.append("return try reader.readAndSeekData()".expressionIndent(with: indentation + 1))
        case .ref(let typeName):
            let type = lookup[typeName]!
            if type is Node {
                result.append("let rootPointer = try reader.readAndSeekLEB()".expressionIndent(with: indentation + 1))
                result.append("return try \(typeName).with(reader: reader, offset: reader.cursor + rootPointer)".expressionIndent(with: indentation + 1))
            } else if type is Enum {
                result.append("return try reader.readAndSeekEnum()".expressionIndent(with: indentation + 1))
            } else if type is UnionType {
                result.append("let typeId = try reader.readAndSeekLEB()".expressionIndent(with: indentation + 1))
                result.append("let currentOffset = reader.cursor".expressionIndent(with: indentation + 1))
                result.append("let value = try reader.readAndSeekLEB()".expressionIndent(with: indentation + 1))
                result.append("guard let unionType = try \(typeName).from(typeId: typeId, value: value, reader: reader, offset: currentOffset) else {".expressionIndent(with: indentation + 1))
                result.append("throw ReaderError.unexpectedUnionCase".expressionIndent(with: indentation + 2))
                result.append("}".expressionIndent(with: indentation + 1))
                result.append("return unionType".expressionIndent(with: indentation + 1))
            } else {
                fatalError("Unexpected type \(type)")
            }
        case .array(let arrayType):
            withOptionals = false
            fallthrough
        case .arrayWithOptionals(let arrayType):
            let suffix = withOptionals ? "WithOptionals" : ""
            switch arrayType {
            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
                result.append("return try reader.readAndSeekNumericArray\(suffix)()".expressionIndent(with: indentation + 1))
            case .bool:
                result.append("return try reader.readAndSeekBoolArray\(suffix)()".expressionIndent(with: indentation + 1))
            case .utf8:
                result.append("return try reader.readAndSeekstringArray\(suffix)()".expressionIndent(with: indentation + 1))
            case .data:
                result.append("return try reader.readAndSeekDataArray\(suffix)()".expressionIndent(with: indentation + 1))
            case .ref(let typeName):
                let type = lookup[typeName]!
                if type is Node {
                    result.append("return try reader.readAndSeekStructArray\(suffix)()".expressionIndent(with: indentation + 1))
                } else if type is Enum {
                    result.append("return try reader.readAndSeekEnumArray\(suffix)()".expressionIndent(with: indentation + 1))
                } else if type is UnionType {
                    result.append("return try reader.readAndSeekUnionTypeArray\(suffix)()".expressionIndent(with: indentation + 1))
                } else {
                    fatalError("Unexpected type \(type)")
                }
            case .array, .arrayWithOptionals:
                fatalError("Does not support arrays")
            }
        }

        result.append("}".expressionIndent(with: indentation))
        return result.joined(separator: "\n")
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    let code =  """
    //  Generated with Dagr on \(dateFormatter.string(from: Date())).
    //  https://github.com/mzaks/dagr
    //

    \(graph.packagesToImport.map{"import \($0)"}.joined(separator: "\n"))

    public enum \(graphName) {
    \(generateEncodeMethod(root:graph.rootType, indentation: indentation + 1, lookup: graph.nodeTypeLookupTable))

    \(generateDecodeMethod(root: graph.rootType, indentation: indentation + 1, lookup: graph.nodeTypeLookupTable))

    \(types.joined(separator: "\n"))
    }
    """
    let fileName = "\(graphName)\(fileNameSuffix).swift"
    let codeFileURL = path.appendingPathComponent(fileName)
    try code.write(to: codeFileURL, atomically: true, encoding: .utf8)
    let data = try JSONEncoder().encode(GenerationProtocol(graph: graph))
    let protocolFileURL = path.appendingPathComponent("\(graphName)_\(UInt64(Date().timeIntervalSince1970)).json")
    try data.write(to: protocolFileURL)
}

func validateCompatibility(graph: DataGraph, path: URL) throws {
    guard let fileNames = FileManager.default.enumerator(atPath: path.path)?.allObjects as? [String] else {
        throw GeneratorError.couldNotEnumarateFolder
    }
    let prefix = "\(graph.name)_"
    let suffix = ".json"
    let protocolFiles = fileNames.filter{$0.hasPrefix(prefix) && $0.hasSuffix(suffix)}
    let timestamps = protocolFiles.compactMap{ UInt64($0.dropFirst(prefix.count).dropLast(suffix.count)) }
    guard let timestamp = timestamps.max() else { return }
    let protocolFile = path.appendingPathComponent("\(prefix)\(timestamp)\(suffix)")
    let data = try Data(contentsOf: protocolFile)
    let generationProtocol = try JSONDecoder().decode(GenerationProtocol.self, from: data)
    try graph.checkCompatiblityWith(previous: generationProtocol.graph)
}

func generate(enum node: Enum, with indentation: Indentation) -> String {
    func caseStatementsEnum(cases: [UInt: String], indentation: Indentation) -> String {
        let sortedKeys = cases.keys.sorted()
        var result = ""
        for key in sortedKeys {
            result.append("case \(cases[key]!) = \(key)\n")
        }
        return result.indent(with: indentation)
    }
    func caseStatementsBitSet(cases: [UInt: String], indentation: Indentation) -> String {
        let sortedKeys = cases.keys.sorted()
        var result = ""
        for key in sortedKeys {
            result.append("public static let \(cases[key]!) = \(node.name)(rawValue: 1 << \(key))\n")
        }
        return result.indent(with: indentation)
    }
    func allCasses(cases: [UInt: String], indentation: Indentation) -> String {
        let sortedKeys = cases.keys.sorted()
        var result = "static let all: \(node.name) = [\n"
        for key in sortedKeys {
            result.append("\(indentation.string).\(cases[key]!),\n")
        }
        result.append("]\n")
        return result.indent(with: indentation)
    }
    if node.asBitSet {
        return """
        public struct \(node.name): OptionSet, EnumNode, Equatable, Hashable, Sendable {
        \(caseStatementsBitSet(cases: node.cases, indentation: indentation + 1))
        \(allCasses(cases: node.cases, indentation: indentation + 1))
            public var value: UInt64 { UInt64(self.rawValue) }
            public let rawValue: Int
            public init(rawValue: Int) {
                self.rawValue = rawValue
            }
            public static func from(value: UInt64) -> \(node.name)? {
                let candidate = \(node.name)(rawValue: Int(value))
                if \(node.name).all.isSuperset(of: candidate) {
                    return candidate
                } else {
                    return nil
                }
            }
            public static var byteWidth: ByteWidth { \(byteWidthBitSet(capacity: node.capacity)) }
        }
        """.indent(with: indentation)
    } else {
        return """
        public enum \(node.name): Int, EnumNode, Equatable, Hashable, Sendable {

        \(caseStatementsEnum(cases: node.cases, indentation: indentation))
            public var value: UInt64 { UInt64(self.rawValue) }
            public static func from(value: UInt64) -> \(node.name)? { return \(node.name)(rawValue: Int(value)) }
            public static func tryFrom(value: UInt64) throws -> \(node.name) { guard let enumValue = \(node.name)(rawValue: Int(value)) else {throw ReaderError.unfittingEnumValue}; return enumValue }
            public static var byteWidth: ByteWidth { \(byteWidth(capacity: node.capacity)) }
        }
        """.indent(with: indentation)
    }

}

func generate(struct node: Node, with indentation: Indentation, lookup: [String: NodeType], nodeNameResolution: [String: String]) -> String {
    func fields(_ fields: [Field], indentation: Indentation) -> String {
        var result = ""
        for field in fields {
            if field.fieldOptions == .deprecated {
                result.append("public private(set)var \(field.name): \(fieldType(field: field, nodeNameResolution: nodeNameResolution)) = \(entryTypeDefault(entry: field.type, defaultValue: field.defaultValue))\n")
            } else {
                result.append("public var \(field.name): \(fieldType(field: field, nodeNameResolution: nodeNameResolution)) = \(entryTypeDefault(entry: field.type, defaultValue: field.defaultValue))\n")
            }
        }
        return result.indent(with: indentation)
    }
    func constructor(_ fields: [Field], indentation: Indentation) -> String {
        func initFields(_ fields: [Field], indentation: Indentation) -> String {
            var result = ""
            for field in fields {
                result.append("\(indentation.string)self.\(field.name) = \(field.name)\n")
            }
            return result
        }
        var result = "public init("
        for (index, field) in fields.enumerated() {
            if field.fieldOptions == .deprecated {
                continue
            }
            result.append("\(field.name): \(typeName(entryType: field.type, nodeNameResolution: nodeNameResolution))")
            if field.fieldOptions.isRequired == false || field.defaultValue != nil {
                if field.fieldOptions.isRequired == false {
                    switch field.type {
                    case .array, .arrayWithOptionals:
                        result.append("")
                    default:
                        result.append("?")
                    }
                }
                result.append(" = \(entryTypeDefault(entry: field.type, defaultValue: field.defaultValue))")
            }
            if index < fields.count - 1 {
                result.append(", ")
            }
        }
        result.append(") {\n")
        result.append(initFields(fields, indentation: indentation))
        result.append("}\n")
        return result.indent(with: indentation)
    }
    func staticFields(prefabs: [String: [String: Value]], indentation: Indentation) -> String {
        var results: [String] = []
        for (prefabName, prefabValues) in prefabs {
            var statement = "nonisolated(unsafe) public static let \(prefabName) = \(node.name)("
            var arguments = [String]()
            for field in node.fields {
                if let value = prefabValues[field.name] {
                    arguments.append("\(field.name): \(entryTypeDefault(entry: field.type, defaultValue: value))")
                }
            }
            statement.append(arguments.joined(separator: ", "))
            statement.append(")")
            results.append(statement)
        }
        return results.joined(separator: "\n").indent(with: indentation)
    }
    return """
    public final class \(node.name): Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

    \(fields(node.fields, indentation: indentation))
        public init() {}
    
    \(constructor(node.fields, indentation: indentation))
    
    \(staticFields(prefabs: node.prefabs, indentation: indentation))

    \(generateApplyFunction(struct: node, indentation: indentation, lookup: lookup))

    \(generateEqualityFunctions(struct: node, indentation: indentation, lookup: lookup))
    
    \(generateHashFunctions(struct: node, indentation: indentation, lookup: lookup))

    \(generateWithReader(struct: node, indentation: indentation, lookup: lookup, nodeNameResolution: nodeNameResolution))
    }
    """.indent(with: indentation)
}

func generate(unionType node: UnionType, with indentation: Indentation, lookup: [String: NodeType], nodeNameResolution: [String: String], graphName: String) -> String {
    func genCases(types: [TypePair], indentation: Indentation) -> String {
        var result = [String]()
        for t in types {
            result.append("\(t.name)(\(typeName(entryType: t.type, nodeNameResolution: nodeNameResolution)))")
        }
        return result.joined(separator: ", ")
    }
    func genTypeId(types: [TypePair], indentation: Indentation) -> String {
        var result = [String]()
        for (index, t) in types.enumerated() {
            result.append("case .\(t.name): return \(index)".expressionIndent(with: indentation))
        }
        return result.joined(separator: "\n")
    }
    func genCycleAwareEquality(types: [TypePair], indentation: Indentation, lookup: [String: NodeType]) -> String {
        var result = [String]()
        for t in types {
            result.append("case .\(t.name)(let selfValue):".expressionIndent(with: indentation))
            result.append("if case .\(t.name)(let otherValue) = other {".expressionIndent(with: indentation + 1))
            switch t.type {
            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
                result.append("return selfValue == otherValue".expressionIndent(with: indentation + 2))
            case .ref(let typeName):
                let nodeType = lookup[typeName]!
                if nodeType is Enum {
                    result.append("return selfValue == otherValue".expressionIndent(with: indentation + 2))
                } else {
                    result.append("return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)".expressionIndent(with: indentation + 2))
                }
            case .array(let arrayType):
                fallthrough
            case .arrayWithOptionals(let arrayType):
                switch arrayType {
                case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
                    result.append("return selfValue == otherValue".expressionIndent(with: indentation + 2))
                case .ref(let typeName):
                    let nodeType = lookup[typeName]!
                    if nodeType is Enum {
                        result.append("return selfValue == otherValue".expressionIndent(with: indentation + 2))
                    } else {
                        result.append("return selfValue.cycleAwareEquality(other: otherValue, visited: &visited)".expressionIndent(with: indentation + 2))
                    }
                case .array, .arrayWithOptionals:
                    fatalError("Unexpected array type")
                }
            }
            result.append("}".expressionIndent(with: indentation + 1))
            result.append("return false".expressionIndent(with: indentation + 1))
        }
        return result.joined(separator: "\n")
    }

    func genCycleAwareHashable(types: [TypePair], indentation: Indentation, lookup: [String: NodeType]) -> String {
        var result = [String]()
        for t in types {
            switch t.type {
            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
                result.append("case .\(t.name)(let value):".expressionIndent(with: indentation))
                result.append("value.hash(into: &hasher)".expressionIndent(with: indentation + 1))
            case .ref(let typeName):
                result.append("case .\(t.name)(let self\(t.name.capitalized)):".expressionIndent(with: indentation))
                let nodeType = lookup[typeName]!
                if nodeType is Enum {
                    result.append("self\(t.name.capitalized).hash(into: &hasher)".expressionIndent(with: indentation + 1))
                } else {
                    result.append("self\(t.name.capitalized).hash(into: &hasher, visited: &visited)".expressionIndent(with: indentation + 1))
                }
            case .array(let arrayType):
                fallthrough
            case .arrayWithOptionals(let arrayType):
                switch arrayType {
                case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
                    result.append("case .\(t.name)(let value):".expressionIndent(with: indentation))
                    result.append("value.hash(into: &hasher)".expressionIndent(with: indentation + 1))
                case .ref(let typeName):
                    result.append("case .\(t.name)(let self\(t.name.capitalized)):".expressionIndent(with: indentation))
                    let nodeType = lookup[typeName]!
                    if nodeType is Enum {
                        result.append("self\(t.name.capitalized).hash(into: &hasher)".expressionIndent(with: indentation + 1))
                    } else {
                        result.append("self\(t.name.capitalized).hash(into: &hasher, visited: &visited)".expressionIndent(with: indentation + 1))
                    }
                case .array, .arrayWithOptionals:
                    fatalError("Unexpected array type")
                }
            }
        }
        return result.joined(separator: "\n")
    }

    func genApplyCase(types: [TypePair], indentation: Indentation, lookup: [String: NodeType]) -> String {
        var result = [String]()

        for (index, t) in types.enumerated() {
            result.append("case .\(t.name)(let value):".expressionIndent(with: indentation))
            var withOptionals = true
            switch t.type {
            case .u8, .u16, .u32, .u64:
                result.append("return .value(value: UInt64(value), id: \(index))".expressionIndent(with: indentation + 1))
            case .i8:
                result.append("return .value(value: UInt64(UInt8(bitPattern: value)), id: \(index))".expressionIndent(with: indentation + 1))
            case .i16:
                result.append("return .value(value: UInt64(UInt16(bitPattern: value)), id: \(index))".expressionIndent(with: indentation + 1))
            case .i32:
                result.append("return .value(value: UInt64(UInt32(bitPattern: value)), id: \(index))".expressionIndent(with: indentation + 1))
            case .i64:
                result.append("return .value(value: UInt64(bitPattern: value), id: \(index))".expressionIndent(with: indentation + 1))
            case .f32, .f64:
                result.append("return .value(value: UInt64(value.bitPattern), id: \(index))".expressionIndent(with: indentation + 1))
            case .bool:
                result.append("return .value(value: value ? 1 : 0, id: \(index))".expressionIndent(with: indentation + 1))
            case .data:
                result.append("return .pointer(value: try builder.store(data: value), id: \(index))".expressionIndent(with: indentation + 1))
            case .utf8:
                result.append("return .pointer(value: try builder.store(string: value), id: \(index))".expressionIndent(with: indentation + 1))
            case .ref(let name):
                let type = lookup[name]!
                if type is Enum {
                    result.append("return .value(value: value.value, id: \(index)".expressionIndent(with: indentation + 1))
                } else if type is UnionType {
                    result.append("return .pointer(value: try builder.store(unionType: value, id: \(index))".expressionIndent(with: indentation + 1))
                } else if type is Node {
                    result.append("if let pointer = try builder.store(structNode: value) {".expressionIndent(with: indentation + 1))
                    result.append("return .bidirPointer(value: pointer, id: \(index))".expressionIndent(with: indentation + 2))
                    result.append("} else {".expressionIndent(with: indentation + 1))
                    result.append("return .reservedPointer(value: ObjectIdentifier(value), id: \(index))".expressionIndent(with: indentation + 2))
                    result.append("}".expressionIndent(with: indentation + 1))
                }
            case .array(let arrayType):
                withOptionals = false
                fallthrough
            case .arrayWithOptionals(let arrayType):
                switch arrayType {
                case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
                    if withOptionals {
                        result.append("return .pointer(value: try builder.storeWithOptionals(numbers: value), id: \(index))".expressionIndent(with: indentation + 1))
                    } else {
                        result.append("return .pointer(value: try builder.store(numbers: value), id: \(index))".expressionIndent(with: indentation + 1))
                    }
                case .bool:
                    if withOptionals {
                        result.append("return .pointer(value: try builder.storeWithOptionals(bools: value), id: \(index))".expressionIndent(with: indentation + 1))
                    } else {
                        result.append("return .pointer(value: try builder.store(bools: value), id: \(index))".expressionIndent(with: indentation + 1))
                    }
                case .utf8:
                    result.append("return .pointer(value: try builder.store(strings: value), id: \(index))".expressionIndent(with: indentation + 1))
                case .data:
                    result.append("return .pointer(value: try builder.store(datas: value), id: \(index))".expressionIndent(with: indentation + 1))
                case .ref(let name):
                    let type = lookup[name]!
                    if type is Enum {
                        if withOptionals {
                            result.append("return .pointer(value: try builder.storeWithOptionals(enums: value), id: \(index))".expressionIndent(with: indentation + 1))
                        } else {
                            result.append("return .pointer(value: try builder.store(enums: value), id: \(index))".expressionIndent(with: indentation + 1))
                        }
                    } else if type is UnionType {
                        if withOptionals {
                            result.append("return .pointer(value: try builder.storeWithOptionals(unionTypes: value), id: \(index))".expressionIndent(with: indentation + 1))
                        } else {
                            result.append("return .pointer(value: try builder.store(unionTypes: value), id: \(index))".expressionIndent(with: indentation + 1))
                        }
                    } else if type is Node {
                        result.append("return .pointer(value: try builder.store(structNodes: value), id: \(index))".expressionIndent(with: indentation + 1))
                    }
                case .array, .arrayWithOptionals:
                    fatalError("No nested arrays")
                }
            }
        }
        return result.joined(separator: "\n")
    }
    func genFromCase(types: [TypePair], indentation: Indentation, lookup: [String: NodeType]) -> String {
        var result = [String]()

        for (index, t) in types.enumerated() {
            var withOptionals = true
            result.append("if typeId == \(index) {".expressionIndent(with: indentation))
            switch t.type {
            case .u8, .u16, .u32, .u64:
                result.append("return .\(t.name)(\(typeName(entryType: t.type, nodeNameResolution: nodeNameResolution))(value))".expressionIndent(with: indentation + 1))
            case .i8:
                result.append("return .\(t.name)(\(typeName(entryType: t.type, nodeNameResolution: nodeNameResolution))(bitPattern: UInt8(value)))".expressionIndent(with: indentation + 1))
            case .i16:
                result.append("return .\(t.name)(\(typeName(entryType: t.type, nodeNameResolution: nodeNameResolution))(bitPattern: UInt16(value)))".expressionIndent(with: indentation + 1))
            case .i32, .f32:
                result.append("return .\(t.name)(\(typeName(entryType: t.type, nodeNameResolution: nodeNameResolution))(bitPattern: UInt32(value)))".expressionIndent(with: indentation + 1))
            case .i64, .f64:
                result.append("return .\(t.name)(\(typeName(entryType: t.type, nodeNameResolution: nodeNameResolution))(bitPattern: value))".expressionIndent(with: indentation + 1))
            case .bool:
                result.append("return .\(t.name)(value == 1 ? true : false)".expressionIndent(with: indentation + 1))
            case .utf8:
                result.append("try reader.seek(by: Int64(value))".expressionIndent(with: indentation + 1))
                result.append("return try .\(t.name)(reader.readAndSeekSting())".expressionIndent(with: indentation + 1))
            case .data:
                result.append("try reader.seek(by: Int64(value))".expressionIndent(with: indentation + 1))
                result.append("return try .\(t.name)(reader.readAndSeekData())".expressionIndent(with: indentation + 1))
            case .ref(let name):
                let type = lookup[name]!
                if type is Node {
                    result.append("let bidirValue = value.fromZigZag".expressionIndent(with: indentation + 1))
                    result.append("if bidirValue < 0 { try reader.seek(to: offset) }".expressionIndent(with: indentation + 1))
                    result.append("try reader.seek(by: bidirValue)".expressionIndent(with: indentation + 1))
                    result.append("return try .\(t.name)(\(graphName).\(type.name).with(reader: reader, offset: reader.cursor))".expressionIndent(with: indentation + 1))
                } else if let enumType = type as? Enum {
                    result.append("guard let enumValue = \(enumType.name).from(value: value) else { throw ReaderError.unfittingEnumValue }".expressionIndent(with: indentation + 1))
                    result.append("return .\(t.name)(enumValue)".expressionIndent(with: indentation + 1))
                } else if type is UnionType {
                    result.append("let typeId = try reader.readAndSeekLEB()".expressionIndent(with: indentation + 1))
                    result.append("let currentOffset = reader.cursor".expressionIndent(with: indentation + 1))
                    result.append("let value = try reader.readAndSeekLEB()".expressionIndent(with: indentation + 1))
                    result.append("return try .\(t.name)(\(graphName).\(type.name).from(typeId: typeId, value: value, reader: reader, offset: currentOffset))".expressionIndent(with: indentation + 1))
                }
            case .array(let arrayType):
                withOptionals = false
                fallthrough
            case .arrayWithOptionals(let arrayType):
                result.append("try reader.seek(by: Int64(value))".expressionIndent(with: indentation + 1))
                let sufix = withOptionals ? "WithOptionals" : ""
                switch arrayType {
                case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
                    result.append("return try .\(t.name)(reader.readAndSeekNumericArray\(sufix)())".expressionIndent(with: indentation + 1))
                case .bool:
                    result.append("return try .\(t.name)(reader.readAndSeekBoolArray\(sufix)())".expressionIndent(with: indentation + 1))
                case .utf8:
                    result.append("return try .\(t.name)(reader.readAndSeekStringArray\(sufix)())".expressionIndent(with: indentation + 1))
                case .data:
                    result.append("return try .\(t.name)(reader.readAndSeekDataArray\(sufix)())".expressionIndent(with: indentation + 1))
                case .ref(let name):
                    let type = lookup[name]!
                    if type is Enum {
                        result.append("return try .\(t.name)(reader.readAndSeekEnumArray\(sufix)())".expressionIndent(with: indentation + 1))
                    } else if type is Node {
                        result.append("return try .\(t.name)(reader.readAndSeekStructArray\(sufix)())".expressionIndent(with: indentation + 1))
                    } else if type is UnionType {
                        result.append("return try .\(t.name)(reader.readAndSeekUnionTypeArray\(sufix)())".expressionIndent(with: indentation + 1))
                    } else {
                        fatalError("Unexpected type \(type)")
                    }
                case .array, .arrayWithOptionals:
                    fatalError("Nested arrays are not supported")
                }
            }
            result.append("}".expressionIndent(with: indentation))
        }
        return result.joined(separator: "\n")
    }
    return """
    public enum \(node.name): UnionNode, Equatable, CycleAwareEquatable, CycleAwareHashable {

        case \(genCases(types: node.types, indentation: indentation))

        public var typeId: UInt64 {
            switch self {
    \(genTypeId(types: node.types, indentation: indentation + 2))
            }
        }

        public static var byteWidth: ByteWidth { \(byteWidth(capacity: node.capacity)) }

        public func cycleAwareEquality(other: Self, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            switch self {
    \(genCycleAwareEquality(types: node.types, indentation: indentation + 2, lookup: lookup))
            }
        }
    
        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
                    switch self {
    \(genCycleAwareHashable(types: node.types, indentation: indentation + 2, lookup: lookup))
            }
        }

        public func apply(builder: Builder) throws -> AppliedUnionType {
            switch self {
    \(genApplyCase(types: node.types, indentation: indentation + 2, lookup: lookup))
            }
        }

        public static func from<T: Reader>(typeId: UInt64, value: UInt64, reader: T, offset: UInt64) throws -> \(node.name)? {
    \(genFromCase(types: node.types, indentation: indentation + 1, lookup: lookup))
            return nil
        }
    }
    """.indent(with: indentation)
}

fileprivate func byteWidth(capacity: UInt16) -> String {
    if capacity <= 2 {
        return ".eighth"
    } else if capacity <= 4 {
        return ".quarter"
    } else if capacity <= 16 {
        return ".half"
    } else if capacity <= UInt16(UInt8.max) {
        return ".one"
    } else if capacity <= UInt16.max {
        return ".two"
    } else {
        fatalError()
    }
}

fileprivate func byteWidthBitSet(capacity: UInt16) -> String {
    if capacity <= 1 {
        return ".eighth"
    } else if capacity <= 2 {
        return ".quarter"
    } else if capacity <= 4 {
        return ".half"
    } else if capacity <= 8 {
        return ".one"
    } else if capacity <= 16 {
        return ".two"
    } else if capacity <= 32 {
        return ".four"
    } else {
        return ".eight"
    }
}


fileprivate func typeName(entryType: EntryType, nodeNameResolution: [String: String]) -> String {
    switch entryType {
    case .u8:
        return "UInt8"
    case .u16:
        return "UInt16"
    case .u32:
        return "UInt32"
    case .u64:
        return "UInt64"
    case .i8:
        return "Int8"
    case .i16:
        return "Int16"
    case .i32:
        return "Int32"
    case .i64:
        return "Int64"
    case .f32:
        return "Float32"
    case .f64:
        return "Float64"
    case .bool:
        return "Bool"
    case .utf8:
        return "String"
    case .data:
        return "Data"
    case .ref(let name):
        if let importedName = nodeNameResolution[name] {
            return importedName
        }
        return name
    case .array(let entryType):
        return "[\(typeName(entryType: entryType, nodeNameResolution: nodeNameResolution))]"
    case .arrayWithOptionals(let entryType):
        return "[\(typeName(entryType: entryType, nodeNameResolution: nodeNameResolution))?]"
    }
}

fileprivate func fieldType(field: Field, nodeNameResolution: [String: String]) -> String {
    var result = typeName(entryType: field.type, nodeNameResolution: nodeNameResolution)
    switch field.type {
    case .array, .arrayWithOptionals:
        break
    default:
        result.append(field.fieldOptions.isRequired ? "!" : "?")
    }

    return result
}

fileprivate func entryTypeDefault(entry: EntryType, defaultValue: Value?) -> String {
    switch defaultValue {
    case .bool(let bool):
        return "\(bool)"
    case .int(let int):
        return "\(int)"
    case .float(let double):
        return "\(double)"
    case .string(let string):
        return "\"\(string)\""
    case .ref(let string):
        return ".\(string)"
    case .unionRef(let typeName, let value):
        return "\(typeName).\(value)"
    case .array(let array):
        switch entry {
        case .array(let arrayType):
            let elements = array.map { entryTypeDefault(entry: arrayType, defaultValue: $0) }.joined(separator: ", ")
            return "[\(elements)]"
        case .arrayWithOptionals(let arrayType):
            let elements = array.map { entryTypeDefault(entry: arrayType, defaultValue: $0) }.joined(separator: ", ")
            return "[\(elements)]"
        default:
            fatalError("Default array value for non-array entry type \(entry.typeName)")
        }

    case .b64Data(let value):
        return "Data(base64Encoded: \(value))"
    case .nil:
        return "nil"
    case nil:
        switch entry {
        case .array, .arrayWithOptionals:
            return "[]"
        default:
            return "nil"
        }
    }
}

fileprivate func generateApplyFunction(struct node: Node, indentation: Indentation, lookup: [String: NodeType]) -> String {
    func applyRefTypes(fields: [Field], indent: Indentation) -> String {
        var result = [String]()
        for field in fields {
            var withOptionals = true
            if field.fieldOptions == .deprecated { continue }
            switch field.type {
            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool:
                break
            case .utf8:
                if field.fieldOptions.isRequired {
                    result.append("let \(field.name)Pointer = try builder.store(string: \(field.name))")
                } else {
                    result.append("let \(field.name)Pointer = try \(field.name).map { try builder.store(string: $0) }")
                }
            case .data:
                if field.fieldOptions.isRequired {
                    result.append("let \(field.name)Pointer = try builder.store(data: \(field.name))")
                } else {
                    result.append("let \(field.name)Pointer = try \(field.name).map { try builder.store(data: $0) }")
                }
            case .ref(let name):
                let nodeType = lookup[name]!
                if nodeType is Enum {
                    break
                } else if nodeType is Node {
                    if field.fieldOptions.isRequired {
                        result.append("let \(field.name)Pointer = try builder.store(structNode: \(field.name))")
                    } else {
                        result.append("let \(field.name)Pointer = try \(field.name).flatMap { try builder.store(structNode: $0) }")
                    }
                } else if nodeType is UnionType {
                    if field.fieldOptions.isRequired {
                        result.append("let \(field.name)AppliedValue = try \(field.name).apply(builder: builder)")
                    } else {
                        result.append("let \(field.name)AppliedValue = try \(field.name)?.apply(builder: builder)")
                    }
                } else {
                    fatalError("Unexpected node type \(nodeType) for name: \(name)")
                }
            case .array(let entryType):
                withOptionals = false
                fallthrough
            case .arrayWithOptionals(let entryType):
                let statementPreffix: String
                if field.fieldOptions.isRequired {
                    statementPreffix = "let \(field.name)Pointer = try builder.store"
                } else {
                    statementPreffix = "let \(field.name)Pointer = \(field.name).isEmpty ? nil : try builder.store"
                }
                switch entryType {
                case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
                    if withOptionals {
                        result.append(
                            "\(statementPreffix)WithOptionals(numbers: \(field.name))"
                        )
                    } else {
                        result.append("\(statementPreffix)(numbers: \(field.name))")
                    }
                case .bool:
                    if withOptionals {
                        result.append(
                            "\(statementPreffix)WithOptionals(bools: \(field.name))"
                        )
                    } else {
                        result.append(
                            "\(statementPreffix)(bools: \(field.name))"
                        )
                    }

                case .utf8:
                    result.append("\(statementPreffix)(strings: \(field.name))")
                case .data:
                    result.append("\(statementPreffix)(datas: \(field.name))")
                case .ref(let name):
                    let nodeType = lookup[name]!
                    if nodeType is Enum {
                        if withOptionals {
                            result.append("\(statementPreffix)WithOptionals(enums: \(field.name))")
                        } else {
                            result.append("\(statementPreffix)(enums: \(field.name))")
                        }
                    } else if nodeType is Node {
                        result.append("\(statementPreffix)(structNodes: \(field.name))")
                    } else if nodeType is UnionType {
                        if withOptionals {
                            result.append("\(statementPreffix)WithOptionals(unionTypes: \(field.name))")
                        } else {
                            result.append("\(statementPreffix)(unionTypes: \(field.name))")
                        }
                    } else {
                        fatalError("Unexpected node type \(nodeType) for name: \(name)")
                    }
                case .array:
                    fatalError("Not supported yet")
                case .arrayWithOptionals:
                    fatalError("Not supported yet")
                }
            }
        }
        return result.joined(separator: "\n").indent(with: indentation)
    }
    func applyValuesAndRefPointers(fields: [Field], indent: Indentation) -> String {
        var result = [String]()
        for field in fields.reversed() {
            if field.fieldOptions == .deprecated { continue }
            switch field.type {
            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
                let fieldName = node.frozen ? "_" : "let \(field.name)ValueCursor"
                if field.fieldOptions.isRequired {
                    result.append("\(fieldName) = try builder.store(number: \(field.name))")
                } else {
                    result.append("\(fieldName) = try \(field.name).map { try builder.store(number: $0) }")
                }
            case .bool:
                let fieldName = node.frozen ? "_" : "let \(field.name)ValueCursor"
                if field.fieldOptions.isRequired {
                    result.append("\(fieldName) = try builder.store(number: \(field.name) ? UInt8(1) : UInt8(0))")
                } else {
                    result.append("\(fieldName) = try \(field.name).map { try builder.store(number: $0 ? UInt8(1) : UInt8(0)) }")
                }
            case .utf8, .data, .array, .arrayWithOptionals:
                let fieldName = node.frozen ? "_" : "let \(field.name)PointerCursor"
                result.append("\(fieldName) = try builder.storeForwardPointer(value: \(field.name)Pointer)")
            case .ref(let name):
                let nodeType = lookup[name]!
                if nodeType is Enum {
                    let fieldName = node.frozen ? "_" : "let \(field.name)PointerCursor"
                    if field.fieldOptions.isRequired {
                        result.append("\(fieldName) = try builder.store(enum: \(field.name))")
                    } else {
                        result.append("\(fieldName) = try \(field.name).map { try builder.store(enum: $0) }")
                    }
                } else if nodeType is Node {
                    let fieldName = node.frozen ? "_" : "\(field.name)PointerCursor"
                    if !node.frozen {
                        result.append("var \(fieldName): UInt64?")
                    }
                    result.append("""
                    if let \(field.name) = \(field.name){
                        if let pointer = \(field.name)Pointer {
                            \(fieldName) = try builder.storeBidirectionalPointer(value: pointer)
                        } else {
                            \(fieldName) = try builder.reserveFieldPointer(for: \(field.name))
                        }
                    }
                    """)
                } else if nodeType is UnionType {
                    let fieldName = node.frozen ? "_" : "let \(field.name)PointerCursor"
                    result.append("\(fieldName) = try \(field.name)AppliedValue.map { try builder.store(unionType: $0) }")
                } else {
                    fatalError("Unexpected node type \(nodeType) for name: \(name)")
                }
            }
        }
        return result.joined(separator: "\n").indent(with: indentation)
    }
    func returnStatement(node: Node, indentation: Indentation) -> String {
        if node.frozen {
            var parameters = [String]()
            for field in node.fields {
                if !field.fieldOptions.isRequired {
                    switch field.type {
                    case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data, .ref:
                        parameters.append("\(field.name) != nil")
                    case .array, .arrayWithOptionals:
                        parameters.append("\(field.name).isEmpty == false")
                    }
                    continue
                }
            }
            if parameters.isEmpty {
                return "return builder.cursor".indent(with: indentation)
            }
            return "return try builder.store(inline: [\(parameters.joined(separator: ", "))].bitSet)".indent(with: indentation)
        } else {
            var parameters = [String]()
            for field in node.fields {
                if field.fieldOptions.contains(.deprecated) {
                    parameters.append("nil")
                    continue
                }
                switch field.type {
                case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool:
                    parameters.append("\(field.name)ValueCursor")
                case .utf8, .data, .ref, .array, .arrayWithOptionals:
                    parameters.append("\(field.name)PointerCursor")
                }
            }
            if node.sparse {
                return "return try builder.storeSparse(vTable: [\(parameters.joined(separator: ", "))])".indent(with: indentation)
            } else {
                return "return try builder.store(vTable: [\(parameters.joined(separator: ", "))])".indent(with: indentation)
            }
        }
    }
    return """
    public func apply(builder: Builder) throws -> UInt64 {
    \(applyRefTypes(fields: node.fields, indent: indentation + 1))
    \(applyValuesAndRefPointers(fields: node.fields, indent: indentation + 1))
    \(returnStatement(node: node, indentation: indentation))
    }
    """.indent(with: indentation)
}

fileprivate func generateEqualityFunctions(struct node: Node, indentation: Indentation, lookup: [String: NodeType]) -> String {
    func unboxOptionalsStatements(fields: [Field], indent: Indentation) -> String {
        var result = [String]()
        for field in fields {
            if field.fieldOptions.contains(.deprecated) { continue }
            switch field.type {

            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data, .array, .arrayWithOptionals:
                continue
            case .ref(let name):
                let type = lookup[name]!
                if type is Enum {
                    continue
                } else {
                    if field.fieldOptions.isRequired {
                        continue
                    } else {
                        let fieldName = field.name
                        let capitalisedName = fieldName.capitalized
                        result.append("""
                        let is\(capitalisedName)Equal: Bool
                        if let \(fieldName) = \(fieldName), let other\(capitalisedName) = other.\(fieldName) {
                            is\(capitalisedName)Equal = \(fieldName).cycleAwareEquality(other: other\(capitalisedName), visited: &visited)
                        } else {
                            is\(capitalisedName)Equal = \(fieldName) == other.\(fieldName)
                        }
                        """)
                    }
                }
            }
        }
        return result.joined(separator: "\n").indent(with: indentation)
    }
    func returnStatement(fields: [Field], indent: Indentation) -> String {
        var string = "return "
        for (index, field) in fields.enumerated() {
            if field.fieldOptions.contains(.deprecated) { continue }
            switch field.type {

            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
                string.append("self.\(field.name) == other.\(field.name)\n")
            case .ref(let name):
                let type = lookup[name]!
                if type is Enum {
                    string.append("self.\(field.name) == other.\(field.name)\n")
                } else {
                    if field.fieldOptions.isRequired {
                        string.append("self.\(field.name).cycleAwareEquality(other: other.\(field.name), visited: &visited)\n")
                    } else {
                        string.append("is\(field.name.capitalized)Equal\n")
                    }
                }
            case .array(let innerType):
                fallthrough
            case .arrayWithOptionals(let innerType):
                switch innerType {
                case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
                    string.append("self.\(field.name) == other.\(field.name)\n")
                case .ref(let name):
                    let type = lookup[name]!
                    if type is Enum {
                        string.append("self.\(field.name) == other.\(field.name)\n")
                    } else {
                        string.append("self.\(field.name).cycleAwareEquality(other: other.\(field.name), visited: &visited)\n")
                    }
                case .array, .arrayWithOptionals:
                    fatalError()
                }
            }
            if index < fields.count - 1 {
                string.append("&& ".expressionIndent(with: indentation + 1))
            }
        }
        return string
    }
    var keyFields = node.fields.filter { $0.fieldOptions.contains(.key) }
    if keyFields.isEmpty {
        keyFields = node.fields
    }
    return """
    public func cycleAwareEquality(other: \(node.name), visited: inout Set<ObjectIdentifierPair>) -> Bool {
        let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
        guard visited.contains(objectIdentifierPair) == false else {
            return true
        }
        visited.insert(objectIdentifierPair)
    \(unboxOptionalsStatements(fields: keyFields, indent: indentation + 1))
        \(returnStatement(fields: keyFields, indent: indentation + 1))
    }
    """.indent(with: indentation)
}

fileprivate func generateHashFunctions(struct node: Node, indentation: Indentation, lookup: [String: NodeType]) -> String {

    func combineStatement(fields: [Field], indent: Indentation) -> String {
        var string = ""
        for (_, field) in fields.enumerated() {
            if field.fieldOptions.contains(.deprecated) { continue }
            switch field.type {

            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
                string.append("hasher.combine(\(field.name))\n")
            case .ref(let name):
                let type = lookup[name]!
                if type is Enum {
                    string.append("hasher.combine(\(field.name))\n")
                } else {
                    if field.fieldOptions.isRequired {
                        string.append("\(field.name).hash(into: &hasher, visited: &visited)\n")
                    } else {
                        string.append("\(field.name)?.hash(into: &hasher, visited: &visited)\n")
                    }
                }
            case .array(let innerType):
                fallthrough
            case .arrayWithOptionals(let innerType):
                switch innerType {
                case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64, .bool, .utf8, .data:
                    string.append("hasher.combine(\(field.name))\n")
                case .ref(let name):
                    let type = lookup[name]!
                    if type is Enum {
                        string.append("hasher.combine(\(field.name))\n")
                    } else {
                        string.append("\(field.name).hash(into: &hasher, visited: &visited)\n")
                    }
                case .array, .arrayWithOptionals:
                    fatalError()
                }
            }
        }
        return string.indent(with: indentation)
    }
    var keyFields = node.fields.filter { $0.fieldOptions.contains(.key) }
    if keyFields.isEmpty {
        keyFields = node.fields
    }
    return """
    public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
        let objectIdentifier = ObjectIdentifier(self)
        guard visited.contains(objectIdentifier) == false else {
            return
        }
        visited.insert(objectIdentifier)
    \(combineStatement(fields: keyFields, indent: indentation + 1))
    }
    """.indent(with: indentation)
}

fileprivate func generateWithReader(struct node: Node, indentation: Indentation, lookup: [String: NodeType], nodeNameResolution: [String: String]) -> String {
    func typeAwareBody(node: Node, indentation: Indentation, lookup: [String: NodeType], nodeNameResolution: [String: String]) -> String {
        var result = [(String, Indentation)]()
        if node.frozen {
            let optionalFieldsCount = node.fields.reduce(0) { partialResult, field in
                return partialResult + (field.fieldOptions.isRequired ? 0 : 1)
            }
            if optionalFieldsCount > 0 {
                result.append(("let optionalFields = try reader.readAndSeekBoolArrayWithLength(length: \(optionalFieldsCount))", indentation))
            }
        } else if node.sparse {
            result.append(("let vTable = try reader.readAndSeekSparseVTable()", indentation))
        } else {
            result.append(("let vTable = try reader.readAndSeekVTable()", indentation))
        }
        if node.frozen == false {
            result.append(("let vTableStartOffest = reader.cursor", indentation))
        }
        let indexedFields = try!node.indexedFields
        var optionalFieldIndex = 0
        for index in indexedFields.keys.sorted() {
            var withOptionals = true
            let field = indexedFields[index]!
            if node.frozen {
                if field.fieldOptions.isRequired {
                    result.append(("do {", indentation))
                } else {
                    result.append(("if optionalFields[\(optionalFieldIndex)] {", indentation))
                    optionalFieldIndex += 1
                }
            } else if node.sparse {
                result.append(("if let \(field.name)Offset = vTable[\(index)] {", indentation))
            } else {
                result.append(("if vTable.count > \(index), let \(field.name)Offset = vTable[\(index)] {", indentation))
            }
            if node.frozen == false {
                result.append(("try reader.seek(by: \(field.name)Offset)", indentation + 1))
            }
            switch field.type {
            case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
                result.append(("result.\(field.name) = try reader.readAndSeekNumeric()", indentation + 1))
            case .bool:
                result.append(("result.\(field.name) = try reader.readAndSeekBool()", indentation + 1))
            case .utf8:
                result.append(("let stringPointer = try reader.readAndSeekLEB()", indentation + 1))
                if node.frozen {
                    result.append(("let currentCursor = reader.cursor", indentation + 1))
                }
                result.append(("try reader.seek(by: Int64(stringPointer))", indentation + 1))
                result.append(("result.\(field.name) = try reader.readSting()", indentation + 1))
                if node.frozen {
                    result.append(("try reader.seek(to: currentCursor)", indentation + 1))
                }
            case .data:
                result.append(("let dataPointer = try reader.readAndSeekLEB()", indentation + 1))
                if node.frozen {
                    result.append(("let currentCursor = reader.cursor", indentation + 1))
                }
                result.append(("try reader.seek(by: Int64(dataPointer))", indentation + 1))
                result.append(("result.\(field.name) = try reader.readData()", indentation + 1))
                if node.frozen {
                    result.append(("try reader.seek(to: currentCursor)", indentation + 1))
                }
            case .ref(let typeName):
                let nodeType = lookup[typeName]!
                let typeName = nodeNameResolution[typeName] ?? typeName
                if let enumType = nodeType as? Enum {
                    result.append(("let \(field.name)Value\(enumReadStatementType(enumType: enumType))", indentation + 1))
                    if field.fieldOptions.isRequired {
                        result.append(("result.\(field.name) = try \(typeName).tryFrom(value: UInt64(\(field.name)Value))", indentation + 1))
                    } else {
                        result.append(("result.\(field.name) = \(typeName).from(value: UInt64(\(field.name)Value))", indentation + 1))
                    }
                } else if nodeType is Node {
                    result.append(("let _pointerOffset = reader.cursor", indentation + 1))
                    result.append(("let \(field.name)Pointer = try reader.readAndSeekSignedLEB()", indentation + 1))
                    if node.frozen {
                        result.append(("let currentCursor = reader.cursor", indentation + 1))
                    }
                    result.append(("if \(field.name)Pointer < 0 { try reader.seek(to: _pointerOffset) }", indentation + 1))
                    result.append(("result.\(field.name) = try \(typeName).with(reader: reader, offset:  UInt64(Int64(reader.cursor) + \(field.name)Pointer))", indentation + 1))
                    if node.frozen {
                        result.append(("try reader.seek(to: currentCursor)", indentation + 1))
                    }
                } else if nodeType is UnionType {
                    result.append(("let typeId = try reader.readAndSeekLEB()", indentation + 1))
                    result.append(("let currentOffset = reader.cursor", indentation + 1))
                    result.append(("let value = try reader.readAndSeekLEB()", indentation + 1))
                    result.append(("result.\(field.name) = try \(typeName).from(typeId: typeId, value: value, reader: reader, offset: currentOffset)", indentation + 1))
                } else {
                    fatalError("Unexpected node type")
                }
            case .array(let arrayType):
                withOptionals = false
                fallthrough
            case .arrayWithOptionals(let arrayType):
                result.append(("let arrayPointer = try reader.readAndSeekLEB()", indentation + 1))
                if node.frozen {
                    result.append(("let currentCursor = reader.cursor", indentation + 1))
                }
                result.append(("try reader.seek(by: Int64(arrayPointer))", indentation + 1))
                let suffix = withOptionals ? "WithOptionals" : ""
                switch arrayType {
                case .u8, .u16, .u32, .u64, .i8, .i16, .i32, .i64, .f32, .f64:
                    result.append(("result.\(field.name) = try reader.readAndSeekNumericArray\(suffix)()", indentation + 1))
                case .bool:
                    result.append(("result.\(field.name) = try reader.readAndSeekBoolArray\(suffix)()", indentation + 1))
                case .data:
                    result.append(("result.\(field.name) = try reader.readAndSeekDataArray\(suffix)()", indentation + 1))
                case .utf8:
                    result.append(("result.\(field.name) = try reader.readAndSeekStringArray\(suffix)()", indentation + 1))
                case .ref(let typeName):
                    let arrayType = lookup[typeName]!
                    if arrayType is Node {
                        result.append(("result.\(field.name) = try reader.readAndSeekStructArray\(suffix)()", indentation + 1))
                    } else if arrayType is Enum {
                        result.append(("result.\(field.name) = try reader.readAndSeekEnumArray\(suffix)()", indentation + 1))
                    } else if arrayType is UnionType {
                        result.append(("result.\(field.name) = try reader.readAndSeekUnionTypeArray\(suffix)()", indentation + 1))
                    }
                case .array, .arrayWithOptionals:
                    fatalError("Nested arrays are not supported")
                }
                if node.frozen {
                    result.append(("try reader.seek(to: currentCursor)", indentation + 1))
                }
            }
            if node.frozen == false {
                result.append(("} else {", indentation))
                if field.fieldOptions == .deprecated {
                    result.append(("// field is deprecated, keep the default value", indentation + 1))
                } else if field.fieldOptions.isRequired {
                    result.append(("throw ReaderError.requiredFieldIsMissing", indentation + 1))
                } else {
                    result.append(("result.\(field.name) = \(entryTypeDefault(entry: field.type, defaultValue: nil))", indentation + 1))
                }
            }

            result.append(("}", indentation))
            if node.frozen == false {
                result.append(("try reader.seek(to: vTableStartOffest)", indentation))
            }
        }
        return result.map { $0.0.indent(with: $0.1) }.joined(separator: "")
    }
    return """
    public static func with<T: Reader>(reader: T, offset: UInt64) throws -> \(node.name) {
        var result: \(node.name)
        let allSet: Bool
        (result, allSet) = try reader.getStructNode(from: offset)
        if allSet {
            return result
        }
        try reader.seek(to: offset)
    \(typeAwareBody(node: node, indentation: indentation, lookup: lookup, nodeNameResolution: nodeNameResolution))
        return result
    }
    """.indent(with: indentation)
}

func enumReadStatementType(enumType: Enum) -> String {
    if enumType.asBitSet {
        if enumType.capacity <= 8 {
            return ": UInt8 = try reader.readAndSeekNumeric()"
        } else if enumType.capacity <= 16 {
            return ": UInt16 = try reader.readAndSeekNumeric()"
        } else if enumType.capacity <= 32 {
            return ": UInt32 = try reader.readAndSeekNumeric()"
        } else if enumType.capacity <= 63 {
            return ": UInt64 = try reader.readAndSeekNumeric()"
        } else {
            fatalError("Unexpected bit set capacity")
        }
    } else {
        if enumType.capacity <= UInt8.max {
            return ": UInt8 = try reader.readAndSeekNumeric()"
        } else if enumType.capacity <= UInt16.max {
            return ": UInt16 = try reader.readAndSeekNumeric()"
        } else {
            fatalError("Unexpected enum capacity")
        }
    }
}

extension String {
    public func expressionIndent(with indentation: Indentation) -> String {
        var result = ""
        for _ in 0..<indentation.depth {
            result.append(indentation.string)
        }
        result.append(self)
        return result
    }

    public func indent(with indentation: Indentation) -> String {
        var result = ""
        self.enumerateLines { line, stop in
            if line.isEmpty {
                result.append("\n")
                return
            }
            for _ in 0..<indentation.depth {
                result.append(indentation.string)
            }
            result.append(line)
            result.append("\n")
        }
        return result
    }
}
