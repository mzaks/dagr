//
//  CompatibilityTests.swift
//  Dagr
//
//  Created by Maxim Zaks on 12.08.25.
//

import Testing
@testable import DagrCodeGen

@Test func validateIncompatibleRootTypes() throws {
    assert(new: DataGraph("", rootType: .f64) {}, compatibleWith: DataGraph("", rootType: .utf8) {}, error: .differentRootTypes)

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Enum("A", ["a"])
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("") {
            "a" ++ .i8
        }
    }), error: .differentRootTypes)
}

@Test func validateTypeChange() throws {
    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
            "b" ++ .ref("B")
        }
        Node("B") {
            "value" ++ .u16
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
            "b" ++ .ref("B")
        }
        Enum("B", cases: [:])
    }), error: .typeWasChanged(typeName: "B", prevType: "Enum", currentType: "Node"))
}

@Test func validateRemoveField() throws {
    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
            "b" ++ .utf8
        }
    }), error: .removedField(nodeName: "A", fieldName: "b"))
}

@Test func validateCahngeFieldType() throws {
    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
            "b" ++ .i64
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
            "b" ++ .utf8
        }
    }), error: .changedFieldType(nodeName: "A", fieldName: "b"))
}

@Test func validateIncomaptibleFieldOptions() throws {
    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .required
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .required
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .deprecated
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .deprecated
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .required
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .deprecated
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .key
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .required
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .key
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .key
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .required
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .key
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .deprecated
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .key
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))

    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32 ++ .key
        }
    }), error: .incompatibleFieldOptions(nodeName: "A", fieldName: "a"))
}

@Test func validateChangeBitset() throws {
    assert(new: DataGraph("", rootType: .ref("E"), types: {
        Enum("E", cases: [:], asBitSet: true)
    }), compatibleWith: DataGraph("", rootType: .ref("E"), types: {
        Enum("E", cases: [:], asBitSet: false)
    }), error: .changedBitsetProperty(enumName: "E"))

    assert(new: DataGraph("", rootType: .ref("E"), types: {
        Enum("E", cases: [:], asBitSet: false)
    }), compatibleWith: DataGraph("", rootType: .ref("E"), types: {
        Enum("E", cases: [:], asBitSet: true)
    }), error: .changedBitsetProperty(enumName: "E"))
}

@Test func validateChangeCapacityEnum() throws {
    assert(new: DataGraph("", rootType: .ref("E"), types: {
        Enum("E", cases: [:], capacity: 10)
    }), compatibleWith: DataGraph("", rootType: .ref("E"), types: {
        Enum("E", cases: [:], capacity: 6)
    }), error: .changedCapacity(name: "E"))
}

@Test func validateChangeCaseNameEnum() throws {
    assert(new: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E")
        }
        Enum("E", cases: [0: "aa"])
    }), compatibleWith: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E")
        }
        Enum("E", cases: [0: "a"])
    }), error: .changedCaseName(enumName: "E", index: 0, prevCaseName: "a", currentCaseName: "aa"))

    assert(new: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E")
        }
        Enum("E", cases: [1: "a"])
    }), compatibleWith: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E")
        }
        Enum("E", cases: [0: "a"])
    }), error: .changedCaseName(enumName: "E", index: 0, prevCaseName: "a", currentCaseName: nil))

    assert(new: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E")
        }
        Enum("E", cases: [0: "a"])
    }), compatibleWith: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E")
        }
        Enum("E", cases: [0: "a", 5: "b"])
    }), error: .changedCaseName(enumName: "E", index: 5, prevCaseName: "b", currentCaseName: nil))
}

@Test func validateStrictEnumChange() throws {
    // strict because it is root
    assert(new: DataGraph("Test", rootType: .ref("E"), types: {
        Enum("E", ["a", "b"])
    }), compatibleWith: DataGraph("Test", rootType: .ref("E"), types: {
        Enum("E", ["a"])
    }), error: .changedStrictEnumUsage(name: "E"))

    // strict because it is referenced by required field
    assert(new: DataGraph("Test", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E") ++ .required
        }
        Enum("E", ["a", "b"])
    }), compatibleWith: DataGraph("Test", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E") ++ .required
        }
        Enum("E", ["a"])
    }), error: .changedStrictEnumUsage(name: "E"))

    // strict because it is referenced in array without optionals
    assert(new: DataGraph("Test", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E").array
        }
        Enum("E", ["a", "b"])
    }), compatibleWith: DataGraph("Test", rootType: .ref("S"), types: {
        Node("S") {
            "e" ++ .ref("E").array
        }
        Enum("E", ["a"])
    }), error: .changedStrictEnumUsage(name: "E"))

    // strict because it is referenced from a union type
    assert(new: DataGraph("Test", rootType: .ref("U"), types: {
        UnionType("U", types: [("e", .ref("E"))])
        Enum("E", ["a", "b"])
    }), compatibleWith: DataGraph("Test", rootType: .ref("U"), types: {
        UnionType("U", types: [("e", .ref("E"))])
        Enum("E", ["a"])
    }), error: .changedStrictEnumUsage(name: "E"))
}

@Test func validateChangeCapacityUnion() throws {
    assert(new: DataGraph("", rootType: .ref("U"), types: {
        UnionType("U", types: [("a", .i32)], capacity: 10)
    }), compatibleWith: DataGraph("", rootType: .ref("U"), types: {
        UnionType("U", types: [("a", .i32)], capacity: 6)
    }), error: .changedCapacity(name: "U"))
}

@Test func validateChangeUnitType() throws {
    assert(new: DataGraph("", rootType: .ref("U"), types: {
        UnionType("U", types: [("a", .i64)])
    }), compatibleWith: DataGraph("", rootType: .ref("U"), types: {
        UnionType("U", types: [("a", .i32)])
    }), error: .changedUnitType(unionTypeName: "U", index: 0))
}

@Test func validateStrictUnionType() throws {
    // strict because it is root
    assert(new: DataGraph("", rootType: .ref("U"), types: {
        UnionType("U", types: [("a", .i64), ("b", .bool)])
    }), compatibleWith: DataGraph("", rootType: .ref("U"), types: {
        UnionType("U", types: [("a", .i64)])
    }), error: .changedStrictUnionTypeUsage(name: "U"))

    // strict because it is referenced by required field
    assert(new: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "u" ++ .ref("U") ++ .required
        }
        UnionType("U", types: [("a", .i64), ("b", .bool)])
    }), compatibleWith: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "u" ++ .ref("U") ++ .required
        }
        UnionType("U", types: [("a", .i64)])
    }), error: .changedStrictUnionTypeUsage(name: "U"))

    // strict because it is referenced in array without optionals
    assert(new: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "u" ++ .ref("U").array
        }
        UnionType("U", types: [("a", .i64), ("b", .bool)])
    }), compatibleWith: DataGraph("", rootType: .ref("S"), types: {
        Node("S") {
            "u" ++ .ref("U").array
        }
        UnionType("U", types: [("a", .i64)])
    }), error: .changedStrictUnionTypeUsage(name: "U"))

    // strict because it is referenced from a union type
    assert(new: DataGraph("", rootType: .ref("RootUnion"), types: {
        UnionType("RootUnion", types: [("u", .ref("U"))])
        UnionType("U", types: [("a", .i64), ("b", .bool)])
    }), compatibleWith: DataGraph("", rootType: .ref("RootUnion"), types: {
        UnionType("RootUnion", types: [("u", .ref("U"))])
        UnionType("U", types: [("a", .i64)])
    }), error: .changedStrictUnionTypeUsage(name: "U"))
}

@Test func validateOnCycle() throws {
    let old = DataGraph("", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
            "friends" ++ .ref("Person").array
            "addressList" ++ .ref("Address").array
        }
        Enum("Gender", ["m", "f", "d"])
        UnionType("Address", types: [("email", .utf8), ("person", .ref("Person"))])
    }
    let new = DataGraph("", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
            "friends" ++ .ref("Person").array
            "addressList" ++ .ref("Address").array
            "happy" ++ .bool
        }
        Enum("Gender", ["m", "f", "d"])
        UnionType("Address", types: [("email", .utf8), ("person", .ref("Person"))])
    }
    try new.checkCompatiblityWith(previous: old)
}

@Test func validateNameChange() throws {
    let old = DataGraph("", rootType: .ref("Person1")) {
        Node("Person1") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
            "friends" ++ .ref("Person1").array
            "addressList" ++ .ref("Address").arrayWithOptionals
        }
        Enum("Gender", ["m", "f", "d"])
        UnionType("Address", types: [("email", .utf8), ("person", .ref("Person1"))], capacity: 4)
    }
    let new = DataGraph("", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Identity")
            "friends" ++ .ref("Person").array
            "contact" ++ .ref("Contact").arrayWithOptionals
            "happy" ++ .bool
        }
        Enum("Identity", ["m", "f", "d"])
        UnionType("Contact", types: [("email", .utf8), ("person", .ref("Person")), ("website", .utf8)])
    }
    try new.checkCompatiblityWith(previous: old)
}

@Test func validateNewFieldShouldNotBeMarkedRequired() throws {
    assert(new: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
            "b" ++ .i32 ++ .required
        }
    }), compatibleWith: DataGraph("", rootType: .ref("A"), types: {
        Node("A") {
            "a" ++ .i32
        }
    }), error: .newFieldShouldNotBeRequired(structName: "A", fieldName: "b"))
}

private func assert(new g1: DataGraph, compatibleWith previous: DataGraph, error: CompatibilityError) {
    #expect(performing: {
        try g1.checkCompatiblityWith(previous: previous)
    }, throws: { e in
        e as! CompatibilityError == error
    })
}
