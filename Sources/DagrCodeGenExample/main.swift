//
//  main.swift
//
//
//  Created by Maxim Zaks on 09.08.25.
//

import Foundation
import DagrCodeGen

func genDataBuilderGraph(outputUrl: URL) throws {
    try generate(
        graph: DataGraph("BuilderSamples", rootType: .array(.ref("Types"))){
            UnionType("Types", types: [
                ("Person1", .ref("Person1")),
                ("Person2", .ref("Person2")),
                ("Person3", .ref("Person3")),
                ("Person4", .ref("Person4")),
                ("Person5", .ref("Person5")),
                ("Person6", .ref("Person6")),
                ("Person7", .ref("Person7")),
                ("Person8", .ref("Person8")),
                ("Person9", .ref("Person9")),
                ("Person10", .ref("Person10")),
                ("Person11", .ref("Person11")),
            ])
            Node("Person1") {
                "name" ++ .utf8
                "age"  ++ .u8
            }
            Node("Person2", frozen: true) {
                "name" ++ .utf8
                "age"  ++ .u8
            }
            Node("Person3", sparse: true) {
                "name" ++ .utf8
                "age"  ++ .u8
            }
            Node("MyDate", frozen: true) {
                "day"   ++ .u8  ++ .required
                "month" ++ .u8  ++ .required
                "year"  ++ .u16 ++ .required
            }
            Node("Person4") {
                "name" ++ .utf8
                "age"  ++ .u8
                "date" ++ .ref("MyDate")
            }
            Node("Person5") {
                "name"      ++ .utf8
                "age"       ++ .u8
                "date"      ++ .ref("MyDate")
                "friend"    ++ .ref("Person5")
            }
            Node("Person6", frozen: true) {
                "name"      ++ .utf8
                "age"       ++ .u8
                "date"      ++ .ref("MyDate")
                "friend"    ++ .ref("Person6")
            }
            Node("Person7") {
                "nameList"          ++ .utf8.array
                "optionalNameList"  ++ .utf8.arrayWithOptionals
                "ages"              ++ .u8.array
                "optionalAges"      ++ .u8.arrayWithOptionals
                "dates"             ++ .ref("MyDate").array
                "friends"           ++ .ref("Person7").arrayWithOptionals
                "bools"             ++ .bool.array
                "optionalBools"     ++ .bool.arrayWithOptionals
            }
            Node("Person8", frozen: true) {
                "nameList"          ++ .utf8.array
                "optionalNameList"  ++ .utf8.arrayWithOptionals
                "ages"              ++ .u8.array
                "optionalAges"      ++ .u8.arrayWithOptionals
                "dates"             ++ .ref("MyDate").array
                "friends"           ++ .ref("Person8").arrayWithOptionals
                "bools"             ++ .bool.array
                "optionalBools"     ++ .bool.arrayWithOptionals
            }

            Enum("Month", ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"])
            Enum("Gender", ["female", "male", "diverse"])
            Enum("Toppings", ["pepperoni", "onions", "greenPeppers", "pineapple"], asBitSet: true)

            Node("Person9") {
                "month"                     ++ .ref("Month")
                "months"                    ++ .ref("Month").array
                "monthsWithOptional"        ++ .ref("Month").arrayWithOptionals
                "toppings"                  ++ .ref("Toppings")
                "multipleToppings"          ++ .ref("Toppings").array
                "multipleOptionalToppings"  ++ .ref("Toppings").arrayWithOptionals
                "gender"                    ++ .ref("Gender")
                "genders"                   ++ .ref("Gender").array
                "gendersWithOptional"       ++ .ref("Gender").arrayWithOptionals
            }

            UnionType("VLQ", types: [
                ("u8", .u8), ("u16", .u16), ("u32", .u32), ("u64", .u64),
            ])

            Node("Person10") {
                "number"            ++ .ref("VLQ")
                "numbers"           ++ .ref("VLQ").array
                "optionalNumbers"   ++ .ref("VLQ").arrayWithOptionals
            }

            UnionType("PersonId", types: [
                ("number", .f64), ("name", .utf8)
            ])
            UnionType("PersonId2", types: [
                ("number", .f64), ("name", .utf8), ("root", .bool), ("int", .i32), ("array", .i32.array), ("ref", .ref("Person11"))
            ])

            Node("Person11") {
                "personId"          ++ .ref("PersonId")
                "personIds"         ++ .ref("PersonId").array
                "optionalPersonIds" ++ .ref("PersonId").arrayWithOptionals
                "personId2"         ++ .ref("PersonId2")
                "personIds2"        ++ .ref("PersonId2").array
            }
        },
        path: outputUrl
    )
}

func main() throws {
    guard CommandLine.arguments.count > 1 else {
        print("Usage: first argument <output-path>")
        return
    }

    let outputPath = CommandLine.arguments[1]

    let outputUrl = URL(string: outputPath)!

    try genDataBuilderGraph(outputUrl: outputUrl)

    print("✅ Generated code at \(outputUrl.absoluteString)")

}
try main()
