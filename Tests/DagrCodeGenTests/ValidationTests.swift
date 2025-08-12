//
//  ValidationTests.swift
//  Dagr
//
//  Created by Maxim Zaks on 12.08.25.
//

import Testing
@testable import DagrCodeGen

@Test func validateNodeCollidingFieldNames() throws {
    let s1 = Node("S1") {
        "a" ++ .utf8
        "b" ++ .i8
        "c" ++ .f32
    }

    #expect(s1.collidingFieldNames.isEmpty)

    let s2 = Node("S2") {
        "a" ++ .utf8
        "b" ++ .i8
        "b" ++ .f32
    }

    #expect(s2.collidingFieldNames.isEmpty == false)
    #expect(Array(s2.collidingFieldNames) == ["b"])

    let s3 = Node("S3") {
        "a" ++ .utf8
        "b" ++ .i8
        "b" ++ .f32
        "c" ++ .i16
        "a" ++ .utf8
    }

    #expect(s3.collidingFieldNames.isEmpty == false)
    #expect(Array(s3.collidingFieldNames.sorted()) == ["a", "b"])

    let s4 = Node("S4") {
        "a" ++ .utf8
        "_b" ++ .i8   ++ .deprecated
        "b" ++ .f32
    }

    #expect(s4.collidingFieldNames.isEmpty)
}

@Test func validateNodeIndexedFields() throws {
    let s1 = Node("S1") {
        "a" ++ .utf8
        "b" ++ .i8
        "c" ++ .f32
    }
    #expect(try s1.indexedFields == [
        0: "a" ++ .utf8 ++ 0,
        1: "b" ++ .i8   ++ 1,
        2: "c" ++ .f32  ++ 2
    ])

    let s2 = Node("S2") {
        "a" ++ .utf8
        "b" ++ .i8   ++ 0
        "c" ++ .f32
    }
    #expect(performing: {
        try s2.indexedFields
    }, throws: { error in
        error.localizedDescription == "Index: 0 is taken by fields: a and b"
    })

    let s3 = Node("S3") {
        "a" ++ .utf8
        "b" ++ .i8   ++ 2
        "c" ++ .f32
    }
    #expect(performing: {
        try s3.indexedFields
    }, throws: { error in
        error.localizedDescription == "Index: 2 is taken by fields: b and c"
    })

    let s4 = Node("S4") {
        "a" ++ .utf8
        "b" ++ .i8   ++ 4
        "c" ++ .f32
    }
    #expect(performing: {
        try s4.indexedFields
    }, throws: { error in
        error.localizedDescription == "Unexpected step from index 0 to 2 named c"
    })

    let s5 = Node("S5") {
        "a" ++ .utf8 ++ 1
        "b" ++ .i8   ++ 2
        "c" ++ .f32  ++ 3
    }
    #expect(performing: {
        try s5.indexedFields
    }, throws: { error in
        error.localizedDescription == "Unexpected step from index -1 to 1 named a"
    })
}

@Test func validateNodeFieldsWithInvalidOptions() throws {
    let s1 = Node("S1") {
        "a" ++ .utf8
        "b" ++ .i8
        "c" ++ .f32
    }

    #expect(s1.fieldsWithInvalidOptions.isEmpty)

    let s2 = Node("S2") {
        "a" ++ .utf8 ++ [.required, .deprecated]
        "b" ++ .i8   ++ .required
        "c" ++ .f32  ++ .deprecated
    }

    #expect(s2.fieldsWithInvalidOptions.isEmpty == false)
    #expect(s2.fieldsWithInvalidOptions == ["a"])
}

@Test func validateEnumCollidingCaseNames() throws {
    let e1 = Enum("E1", ["a", "b", "c"])
    #expect(e1.collidingCaseNames.isEmpty)

    let e2 = Enum("E2", ["a", "b", "a"])
    #expect(e2.collidingCaseNames.isEmpty == false)
    #expect(e2.collidingCaseNames == ["a"])

    let e3 = Enum("E3", ["a", "b", "b", "a"])
    #expect(e3.collidingCaseNames.isEmpty == false)
    #expect(e3.collidingCaseNames.sorted() == ["a", "b"])
}

@Test func validateEnumOverCapacity() throws {
    let e1 = Enum("E1", ["a", "b", "c"])
    #expect(e1.isOverCapaicty == false)

    let e2 = Enum("E2", ["a", "b", "c"], capacity: 2)
    #expect(e2.isOverCapaicty == true)
}

@Test func validateUnionTypeCollidingTypeNames() throws {
    let u1 = UnionType("U1", types: [("a", .u8), ("b", .u16), ("c", .utf8)])
    #expect(u1.collidingTypeNames.isEmpty)

    let u2 = UnionType("U2", types: [("a", .u8), ("b", .u16), ("a", .utf8)])
    #expect(u2.collidingTypeNames.isEmpty == false)
    #expect(u2.collidingTypeNames == ["a"])

    let u3 = UnionType("U3", types: [("a", .u8), ("b", .u16), ("a", .utf8), ("b", .ref("Some"))])
    #expect(u3.collidingTypeNames.isEmpty == false)
    #expect(u3.collidingTypeNames.sorted() == ["a", "b"])
}

@Test func validateUnionTypeOverCapacity() throws {
    let u1 = UnionType("U1", types: [("a", .u8), ("b", .u16), ("c", .utf8)])
    #expect(u1.isOverCapaicty == false)

    let u2 = UnionType("U2", types: [("a", .u8), ("b", .u16), ("c", .utf8)], capacity: 2)
    #expect(u2.isOverCapaicty == true)
}

@Test func validateDataGraphDupplicateType() throws {
    let g1 = DataGraph("", rootType: .u8) {
        Node("Person") {
            "name" ++ .utf8
        }
        Enum("Gender", ["m", "f", "d"])
    }

    #expect(g1.duplicateNodeTypes.isEmpty)

    let g2 = DataGraph("", rootType: .u8) {
        Node("Person") {
            "name" ++ .utf8
        }
        Enum("Person", ["m", "f", "d"])
    }

    #expect(g2.duplicateNodeTypes.isEmpty == false)
    #expect(g2.duplicateNodeTypes.keys.sorted() == ["Person"])
}

@Test func validateDataGraphUnresolvedReferences() throws {
    let g1 = DataGraph("", rootType: .u8) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
        }
        Enum("Gender", ["m", "f", "d"])
    }

    #expect(g1.unresolvedTypeReferences.isEmpty)

    let g2 = DataGraph("", rootType: .u8) {
        Node("Person") {
            "name" ++ .ref("Gender1")
            "listOfFriends" ++ .ref("Person").array.array
        }
        Enum("Gender", ["m", "f", "d"])
        UnionType("U1", types: [("person", .ref("Person")), ("people", .ref("Gender").array), ("wrong", .ref("Wrong")), ("wrongArray", .ref("Wrong2").array.array)])
    }

    #expect(g2.unresolvedTypeReferences.isEmpty == false)
    #expect(g2.unresolvedTypeReferences.sorted() == ["Gender1", "Wrong", "[[Wrong2]]"])
}

@Test func validateDataGraphRootTypeValid() throws {
    let g1 = DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
        }
        Enum("Gender", ["m", "f", "d"])
    }
    try g1.validate()

    assert(DataGraph("G", rootType: .ref("Something")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
        }
        Enum("Gender", ["m", "f", "d"])
    }, error: .rootTypeIsNotValidReference)
}

@Test func validateDataGraphValidateDuplicateNodes() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
        }
        Node("Gender") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
        }
        Enum("Gender", ["m", "f", "d"])
    }, error: .dupplicateNodes(names: ["Gender"]))
}

@Test func validateDataGraphValidateUnresolvedReferences() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
            "address" ++ .ref("PostalAddress")
        }
        Node("PostalAddress") {
            "street" ++ .utf8
            "country" ++ .utf8
            "zip" ++ .ref("Zip")
        }
        Enum("Gender", ["m", "f", "d"])
    }, error: .unresolvedReferences(names: ["Zip"]))
}

@Test func validateDataGraphValidateCollidingFieldNames() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
            "address" ++ .ref("PostalAddress")
        }
        Node("PostalAddress") {
            "street" ++ .utf8
            "country" ++ .utf8
            "zip" ++ .utf8
            "street" ++ .data
        }
        Enum("Gender", ["m", "f", "d"])
    }, error: .collidingFieldNames(nodeName: "PostalAddress", fieldNames: ["street"]))
}

@Test func validateDataGraphValidateFieldWithInvalidOptions() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
            "address" ++ .ref("PostalAddress")
        }
        Node("PostalAddress") {
            "street" ++ .utf8
            "country" ++ .utf8 ++ [.deprecated, .required]
            "zip" ++ .utf8 ++ [.deprecated, .key]
        }
        Enum("Gender", ["m", "f", "d"])
    }, error: .fieldsWithInvalidOptions(nodeName: "PostalAddress", fieldNames: ["country", "zip"]))
}

@Test func validateDataGraphValidateIndexedAlreadyTaken() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name"   ++ .utf8          ++ 0
            "gender" ++ .ref("Gender") ++ 0
        }
        Enum("Gender", ["m", "f", "d"])
    }, error: .nodeError(nodeName: "Person", error: .indexIsAlreadyTaken(index: 0, name1: "name", name2: "gender")))
}

@Test func validateDataGraphValidateUnexpectedIndexStep() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name"   ++ .utf8          ++ 0
            "gender" ++ .ref("Gender") ++ 2
        }
        Enum("Gender", ["m", "f", "d"])
    }, error: .nodeError(nodeName: "Person", error: .unexpectedIndexStep(index: 2, prevIndex: 0, fieldName: "gender")))
}

@Test func validateDataGraphValidateEnumOverCapacity() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
        }
        Enum("Gender", ["m", "f", "d"], capacity: 2)
    }, error: .enumOvercapacity(enumName: "Gender"))
}

@Test func validateDataGraphValidateEnumCollidingCases() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
        }
        Enum("Gender", ["m", "f", "d", "m"])
    }, error: .enumCollidingCaseNames(enumName: "Gender", caseNames: ["m"]))

}

@Test func validateDataGraphValidateUnionOverCapacity() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
            "addressList" ++ .ref("Address").array
        }
        Node("PostalAddress", frozen: true) {
            "street" ++ .utf8 ++ .required
            "city"   ++ .utf8 ++ .required
            "zip"    ++ .utf8 ++ .required
        }
        UnionType("Address", types: [("postal", .ref("PostalAddress")), ("email", .utf8), ("phone", .utf8)], capacity: 2)
        Enum("Gender", ["m", "f", "d"])
    }, error: .unionTypeOvercapacity(unionTypeName: "Address"))
}

@Test func validateDataGraphValidateUnionCollidingNames() throws {
    assert(DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
            "addressList" ++ .ref("Address").array
        }
        Node("PostalAddress", frozen: true) {
            "street" ++ .utf8 ++ .required
            "city"   ++ .utf8 ++ .required
            "zip"    ++ .utf8 ++ .required
        }
        UnionType("Address", types: [("postal", .ref("PostalAddress")), ("email", .utf8), ("phone", .utf8), ("postal", .utf8)])
        Enum("Gender", ["m", "f", "d"])
    }, error: .unionTypeCollidingNames(unionTypeName: "Address", typeNames: ["postal"]))
}

@Test func validateDataGraphOnCycle() throws {
    try DataGraph("G", rootType: .ref("Person")) {
        Node("Person") {
            "name" ++ .utf8
            "gender" ++ .ref("Gender")
            "friends" ++ .ref("Person").array
            "addressList" ++ .ref("Address").array
        }
        Enum("Gender", ["m", "f", "d"])
        UnionType("Address", types: [("email", .utf8), ("person", .ref("Person"))])
    }.validate()
}

private func assert(_ g: DataGraph, error: ValidationError) {
    #expect(performing: {
        try g.validate()
    }, throws: { e in
        e as! ValidationError == error
    })
}
