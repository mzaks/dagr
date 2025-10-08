//
//  JSONLikeTests.swift
//  Dagr
//
//  Created by MacBookProMax on 07.10.25.
//

import Testing

@Test func validateWithPrimitiveValues() throws {
    do {
        let d = try JSONLike.encode(root: .bool(true))
        let v = try JSONLike.decode(data: d)
        if case .bool(let b) = v {
            #expect(b == true)
        } else {
            Issue.record("the decode value is not a bool")
        }
    }
    do {
        let d = try JSONLike.encode(root: .bool(false))
        let v = try JSONLike.decode(data: d)
        if case .bool(let b) = v {
            #expect(b == false)
        } else {
            Issue.record("the decode value is not a bool")
        }
    }
    do {
        let d = try JSONLike.encode(root: .string("hello"))
        let v = try JSONLike.decode(data: d)
        if case .string(let s) = v {
            #expect(s == "hello")
        } else {
            Issue.record("the decode value is not a string")
        }
    }
    do {
        let d = try JSONLike.encode(root: .number(1234.567))
        let v = try JSONLike.decode(data: d)
        if case .number(let n) = v {
            #expect(n == 1234.567)
        } else {
            Issue.record("the decode value is not a number")
        }
    }
}

@Test func validateWithArrayOfValues() throws {
    do {
        let d = try JSONLike.encode(root: .array([.string("a"), .bool(true), .number(345.678), nil]))
        let v = try JSONLike.decode(data: d)
        if case .array(let a) = v {
            #expect(a.count == 4)
            if case .string(let s) = a[0] {
                #expect(s == "a")
            } else {
                Issue.record("the decode value is not a string")
            }
            if case .bool(let b) = a[1] {
                #expect(b == true)
            } else {
                Issue.record("the decode value is not a bool")
            }
            if case .number(let n) = a[2] {
                #expect(n == 345.678)
            } else {
                Issue.record("the decode value is not a number")
            }
            #expect(a[3] == nil)
        } else {
            Issue.record("the decode value is not an array")
        }
    }
}

@Test func validateWithDict() throws {
    
    let d = try JSONLike.encode(root: .dict([
        .init(key: "a", value: .number(123)),
        .init(key: "b"),
        .init(key: "c", value: .string("hello")),
        .init(key: "d", value: .array([.bool(true), .number(123)]))
    ]))
    let v = try JSONLike.decode(data: d)
    if case .dict(let d) = v {
        #expect(d.count == 4)
        
        #expect(d[0].key == "a")
        if case .number(let n) = d[0].value {
            #expect(n == 123)
        } else {
            Issue.record("the decode value is not a number")
        }
        
        #expect(d[1].key == "b")
        #expect(d[1].value == nil)
        
        #expect(d[2].key == "c")
        if case .string(let s) = d[2].value {
            #expect(s == "hello")
        } else {
            Issue.record("the decode value is not a string")
        }
        
        #expect(d[3].key == "d")
        if case .array(let a) = d[3].value {
            #expect(a.count == 2)
            if case .bool(let b) = a[0] {
                #expect(b == true)
            } else {
                Issue.record("the decode value is not a bool")
            }
            if case .number(let n) = a[1] {
                #expect(n == 123)
            } else {
                Issue.record("the decode value is not a number")
            }
        } else {
            Issue.record("the decode value is not an array")
        }
        
    } else {
        Issue.record("the decode value is not a dict")
    }
    
}


@Test func validateWithNestedDict() throws {
    
    let d = try JSONLike.encode(root: .dict([
        .init(key: "a"),
        .init(key: "b", value: .dict([
            .init(key: "a", value: .number(25)),
            .init(key: "o"),
            .init(key: "b", value: .dict([
                .init(key: "e"),
                .init(key: "d")
            ])),
        ])),
        
    ]))
    let v = try JSONLike.decode(data: d)
    if case .dict(let d) = v {
        #expect(d.count == 2)
        
        #expect(d[0].key == "a")
        #expect(d[0].value == nil)
        
        #expect(d[1].key == "b")
        if case .dict(let d) = d[1].value {
            #expect(d.count == 3)
            
            #expect(d[0].key == "a")
            if case .number(let n) = d[0].value {
                #expect(n == 25)
            } else {
                Issue.record("the decode value is not a number")
            }
            
            #expect(d[1].key == "o")
            #expect(d[1].value == nil)
            
            #expect(d[2].key == "b")
            if case .dict(let d) = d[2].value {
                #expect(d.count == 2)
                
                #expect(d[0].key == "e")
                #expect(d[0].value == nil)
                #expect(d[1].key == "d")
                #expect(d[1].value == nil)
            } else {
                Issue.record("the decode value is not a dict")
            }
        } else {
            Issue.record("the decode value is not a dict")
        }
    } else {
        Issue.record("the decode value is not a dict")
    }
    
}

@Test func validateWithNestedDictReadOverExtension() throws {
    
    let d = try JSONLike.encode(root: .dict([
        .init(key: "b", value: .dict([
            .init(key: "a", value: .number(25)),
            .init(key: "b", value: .dict([
                .init(key: "e", value: .bool(true)),
                .init(key: "d", value: .bool(false))
            ])),
        ])),
        
    ]))
    
    let v = try JSONLike.decode(data: d).dict
    #expect(v?.count == 1)
    let vb = v?["b"]?.dict
    #expect(vb?.count == 2)
    #expect(vb?["a"]?.number == 25)
    #expect(vb?["b"]?.count == 2)
    #expect(vb?["b"]?.dict?["e"]?.bool == true)
    #expect(vb?["b"]?.dict?["d"]?.bool == false)
}

@Test func validateJSONLikeCannotProduceCycle() throws {
    var p = JSONLike.Value.dict([
        .init(key: "name", value: .string("Max"))
    ])
    p["friend"] = p
    p["numbers"] = .array([.number(1), .number(2)])
    p["numbers"]?.append(.bool(true))
    
    p["numbers"]?[1] = .number(4)
    
    let d = try JSONLike.encode(root:p)
    
    let v = try JSONLike.decode(data: d)
    
    #expect(v == p)
    
    #expect(v["name"]?.string == "Max")
    #expect(v["numbers"]?.count == 3)
    #expect(v["numbers"]?[0]?.number == 1)
    #expect(v["numbers"]?[1]?.number == 4)
    #expect(v["numbers"]?[2]?.bool == true)
    
    #expect(v["friend"]?["name"]?.string == "Max")
    #expect(v["friend"]?["friend"]?["name"]?.count == nil)
}

@Test func validateJSONLikeCanProducePartialCycles() throws {
    var p1 = JSONLike.Value.dict([
        .init(key: "name", value: .string("Max"))
    ])
    var p2 = JSONLike.Value.dict([
        .init(key: "name", value: .string("Alex"))
    ])
    var p3 = JSONLike.Value.dict([
        .init(key: "name", value: .string("Leo"))
    ])
    
    p2["friends"] = .array([p3])        // p3 does not have friends yet
    p3["friends"] = .array([p1])        // p1 does not have friends yet
    p1["friends"] = .array([p2, p3])    // we will be able to go from p1 to p2 and p3,
                                        // from p2 to p3, from p3 to p1,
                                        // but an older version of p1 without friends
                                        // this is due to the fact that
                                        // union nodes are represented with enums
                                        // which are value types
    
    let d = try JSONLike.encode(root:p1)
    
    let v = try JSONLike.decode(data: d)
    
//    print(v.description)
//    print(v.description.count)
//    {"name":"Max","friends":[{"name":"Alex","friends":[{"name":"Leo"}]},{"name":"Leo","friends":[{"name":"Max"}]}]}
    
    #expect(v == p1)
    
    #expect(v["name"]?.string == "Max")
    #expect(v["friends"]?.count == 2)
    
    #expect(v["friends"]?[0]?["name"]?.string == "Alex")
    #expect(v["friends"]?[0]?["friends"]?.count == 1)
    #expect(v["friends"]?[0]?["friends"]?[0]?["name"]?.string == "Leo")
    #expect(v["friends"]?[0]?["friends"]?[0]?["friends"] == nil) // When Leo was assigned as friend to Alex he did not have friends yet
    #expect(v["friends"]?[1]?["name"]?.string == "Leo")
    #expect(v["friends"]?[1]?["friends"]?.count == 1)
    #expect(v["friends"]?[1]?["friends"]?[0]?["name"]?.string == "Max")
    #expect(v["friends"]?[1]?["friends"]?[0]?["friends"] == nil) // as it is an old version of Max, before he got friends assigned
}
