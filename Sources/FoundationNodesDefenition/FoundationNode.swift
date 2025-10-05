//
//  FoundationNode.swift
//  Dagr
//
//  Created by MacBookProMax on 04.10.25.
//

import DagrCodeGen

nonisolated(unsafe) public let foundationNodesGraph = DataGraph("FoundationNode", rootType: .bool, types: {
    Node("UUID", frozen: true) {
        "a" ++ .u8 ++ .required
        "b" ++ .u8 ++ .required
        "c" ++ .u8 ++ .required
        "d" ++ .u8 ++ .required
        "e" ++ .u8 ++ .required
        "f" ++ .u8 ++ .required
        "g" ++ .u8 ++ .required
        "h" ++ .u8 ++ .required
        "i" ++ .u8 ++ .required
        "j" ++ .u8 ++ .required
        "k" ++ .u8 ++ .required
        "l" ++ .u8 ++ .required
        "m" ++ .u8 ++ .required
        "n" ++ .u8 ++ .required
        "o" ++ .u8 ++ .required
        "p" ++ .u8 ++ .required
    }
    Node("UTCTimestamp", frozen: true) {
        "value" ++ .f64 ++ .required
    }
    Node("URL", frozen: true) {
        "scheme"    ++ .utf8
        "user"      ++ .utf8
        "password"  ++ .utf8
        "host"      ++ .utf8
        "port"      ++ .u16
        "path"      ++ .utf8
        "query"     ++ .utf8
        "fragment"  ++ .utf8
    }
})
