import Testing
import Foundation
import FoundationNodes
@testable import Dagr

typealias Person6 = BuilderSamples.Person6
typealias Person7 = BuilderSamples.Person7
typealias Person8 = BuilderSamples.Person8
typealias Person9 = BuilderSamples.Person9
typealias Person10 = BuilderSamples.Person10
typealias Person11 = BuilderSamples.Person11
typealias Person12 = BuilderSamples.Person12
typealias PersonId = BuilderSamples.PersonId
typealias PersonId2 = BuilderSamples.PersonId2
typealias StringDict1 = BuilderSamples.StringDict1
typealias StringDict2 = BuilderSamples.StringDict2
typealias StringDict3 = BuilderSamples.StringDict3
typealias StringDict4 = BuilderSamples.StringDict4
typealias StringDict5 = BuilderSamples.StringDict5
typealias StringDict6 = BuilderSamples.StringDict6

@Test func validateRoundTripPerson1() throws {
    do {
        let p1 = Person1(name: "Maxim", age: 40)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person1.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
    do {
        let p1 = Person1(name: "Maxim", age: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person1.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
    do {
        let p1 = Person1(name: nil, age: 40)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person1.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
    do {
        let p1 = Person1(name: nil, age: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person1.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
}

@Test func validateRoundTripPerson2() throws {
    do {
        let p1 = Person2(name: "Maxim", age: 40)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person2.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
    do {
        let p1 = Person2(name: "Maxim", age: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person2.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
    do {
        let p1 = Person2(name: nil, age: 40)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person2.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
    do {
        let p1 = Person1(name: nil, age: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person1.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
}

@Test func validateRoundTripPerson3() throws {
    do {
        let p1 = Person3(name: "Maxim", age: 40)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person3.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
    do {
        let p1 = Person3(name: "Maxim", age: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person3.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
    do {
        let p1 = Person3(name: nil, age: 40)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person3.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
    do {
        let p1 = Person3(name: nil, age: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person3.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1.name == p2.name)
        #expect(p1.age == p2.age)
    }
}

@Test func validateRoundTripPerson4() throws {
    do {
        let p1 = Person4(name: "Maxim", age: 40, date: MyDate(day: 11, month: 11, year: 1980))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person4.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person4(name: "Maxim", age: 40, date: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person4.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person4(name: nil, age: nil, date: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person4.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
}

@Test func validateRoundTripPerson5() throws {
    do {
        let p1 = Person5(name: "Maxim", age: 40, date: MyDate(day: 11, month: 11, year: 1980), friend: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person5.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person5(name: "Maxim", age: 40, date: MyDate(day: 11, month: 11, year: 1980), friend: Person5(name: "David"))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person5.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person5(name: "Maxim", age: 40, date: MyDate(day: 11, month: 11, year: 1980), friend: Person5(name: "David", date: MyDate(day: 11, month: 11, year: 1980)))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person5.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person5(name: "Maxim", age: 40, date: MyDate(day: 11, month: 11, year: 1980))
        p1.friend = p1
        let builder = DataBuilder()
        let offset = try builder.store(structNode: p1)!
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person5.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
}

@Test func validateRoundTripPerson6() throws {
    do {
        let p1 = Person6(name: "Maxim", age: 40, date: MyDate(day: 11, month: 11, year: 1980), friend: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person6.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person6(name: "Maxim", age: 40, date: MyDate(day: 11, month: 11, year: 1980), friend: Person6(name: "David"))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person6.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person6(name: "Maxim", age: 40, date: MyDate(day: 11, month: 11, year: 1980), friend: Person6(name: "David", date: MyDate(day: 11, month: 11, year: 1980)))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person6.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person6(name: "Maxim", age: 40, date: MyDate(day: 11, month: 11, year: 1980))
        p1.friend = p1
        let builder = DataBuilder()
        let offset = try builder.store(structNode: p1)!
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person6.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
}

@Test func validateRoundTripPerson7() throws {
    do {
        let p1 = Person7(nameList: ["Maxim", "Alex"])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person7(optionalNameList: ["Maxim", nil, "Alex"])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person7(nameList: ["Alice", "Bob"], optionalNameList: ["Maxim", nil, "Alex"])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person7(ages:[12, 40, 32])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person7(optionalAges:[12, nil, 40, 32])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person7(nameList: ["Maxim", "Alex"], optionalAges:[12, nil, 40, 32], dates: [MyDate(day: 1, month: 1, year: 1980), MyDate(day: 19, month: 11, year: 1980)])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person7(friends:[Person7(nameList:["Maxim"]), Person7(nameList:["Alex"]), nil, Person7(nameList:["Maxim"], ages: [13])])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let maxim1 = Person7(nameList:["Maxim"])
        let maxim2 = Person7(nameList:["Maxim"], ages:[13])
        let alex = Person7(nameList:["Alex"])
        maxim2.friends = [maxim1, alex]
        alex.friends = [maxim2]
        let builder = DataBuilder()
        let offset = try builder.store(structNode: alex)!
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(alex == p2)
    }
    do {
        let p1 = Person7(nameList:["P1"])
        let p2 = Person7(nameList:["P2"])
        let p3 = Person7(nameList:["P3"])
        p1.friends = [p2, p3]
        p2.friends = [p1, p3, p3]
        p3.friends = [p3, p1, p1]
        let builder = DataBuilder()
        let offset = try builder.store(structNode: p1)!
        let data = builder.makeData
        let reader = DataReader(data: data)
        let _p1 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(_p1 == p1)
    }
    do {
        let p1 = Person7(bools: [true, false, true, false])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person7(bools: [true, false, true, false], optionalBools: [nil, nil, true, false, nil])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person7.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
}

@Test func validateRoundTripPerson8() throws {
    do {
        let p1 = Person8(nameList: ["Maxim", "Alex"])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person8(optionalNameList: ["Maxim", nil, "Alex"])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person8(nameList: ["Alice", "Bob"], optionalNameList: ["Maxim", nil, "Alex"])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person8(ages:[12, 40, 32])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person8(optionalAges:[12, nil, 40, 32])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person8(nameList: ["Maxim", "Alex"], optionalAges:[12, nil, 40, 32], dates: [MyDate(day: 1, month: 1, year: 1980), MyDate(day: 19, month: 11, year: 1980)])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person8(friends:[Person8(nameList:["Maxim"]), Person8(nameList:["Alex"]), nil, Person8(nameList:["Maxim"], ages: [13])])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let maxim1 = Person8(nameList:["Maxim"])
        let maxim2 = Person8(nameList:["Maxim"], ages:[13])
        let alex = Person8(nameList:["Alex"])
        maxim2.friends = [maxim1, alex]
        alex.friends = [maxim2]
        let builder = DataBuilder()
        let offset = try builder.store(structNode: alex)!
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(alex == p2)
    }
    do {
        let p1 = Person8(bools: [true, false, true, false])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person8(bools: [true, false, true, false], optionalBools: [nil, nil, true, false, nil])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person8.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
}

@Test func validateRoundTripPerson9() throws {
    do {
        let p1 = Person9(month:.apr)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person9.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person9(month:.apr, months: [.jun, .jul])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person9.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person9(month:.apr, months: [.jun, .jul], monthsWithOptional: [nil, .aug, nil, .sep])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person9.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person9(month:.apr, months: [.jun, .jul], monthsWithOptional: [nil, .aug, nil, .sep], toppings: [.greenPeppers, .onions])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person9.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person9(month:.apr, months: [.jun, .jul], monthsWithOptional: [nil, .aug, nil, .sep], toppings: [.greenPeppers, .onions], multipleToppings: [.all, [.onions, .pineapple], []])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person9.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person9(month:.apr, months: [.jun, .jul], monthsWithOptional: [nil, .aug, nil, .sep], toppings: [.greenPeppers, .onions], multipleOptionalToppings: [.all, nil, [.onions, .pineapple], []])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person9.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person9(month:.apr, gender: .diverse)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person9.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person9(month:.apr, genders: [.diverse, .female, .male, .male, .female, .diverse])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person9.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person9(month:.apr, gendersWithOptional: [.diverse, .female, nil, .male, .male, .female, .diverse, nil, nil])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person9.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
}

@Test func validateRoundTripPerson10() throws {
    do {
        let p1 = Person10(number:.u32(12))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person10.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person10(number:.u32(12), numbers: [.u32(12), .u8(16)])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person10.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person10(number:.u32(12), numbers: [.u32(1200), .u8(16)])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person10.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person10(number:.u32(12), numbers: [.u32(120_000), .u8(16)])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person10.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person10(number:.u32(12), numbers: [.u32(120_000), .u8(16)], optionalNumbers: [nil, .u64(456789), .u8(12), nil])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person10.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
}

@Test func validateRoundTripPerson11() throws {
    do {
        let p1 = Person11(personId: .number(0.5))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .name("Maxim"))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .name("Maxim"), personIds: [.name("Maxim"), .number(1.1), .name("Alex"), .number(1234)])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .name("Maxim"), optionalPersonIds: [nil, .name("Maxim"), .number(1.1), .name("Alex"), nil, .number(1234), nil, nil, nil])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .number(0.5), personId2: .number(0.1))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .number(0.5), personId2: .name("Max"))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .number(0.5), personId2: .array([1, 2, 3]))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .number(0.5), personId2: .root(false))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .number(0.5), personId2: .int(-234))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .number(0.5), personId2: .ref(Person11(personId:.name("Max"))))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .number(0.5))
        p1.personId2 = .ref(p1)
        let builder = DataBuilder()
        let offset = try builder.store(structNode: p1)!
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .number(0.5), personIds2: [.ref(Person11(personId:.name("Max")))])
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person11(personId: .number(0.5))
        p1.personIds2 = [.ref(p1), .ref(Person11(personId:.name("Max"))), .int(-675894)]
        let builder = DataBuilder()
        let offset = try builder.store(structNode: p1)!
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person11.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
}

@Test func validateRoundTripPerson12() throws {
    do {
        let p1 = Person12()
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person12.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person12(name: "Maxim", active: false, gender: .male, genders1: [.female], genders2: [], date: nil)
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person12.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person12(name: "Alex", active: nil, gender: .female, genders1: [], genders2: [.male], date: MyDate(day: 1, month: 2, year: 2024))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person12.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
    }
    do {
        let p1 = Person12(id:FoundationNode.UUID(a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10, k: 11, l: 12, m: 13, n: 14, o: 15, p: 16))
        let builder = DataBuilder()
        let offset = try p1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let p2 = try Person12.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(p1 == p2)
        #expect(p1.id?.string == "01020304-0506-0708-090a-0b0c0d0e0f10")
        #expect(p1.id?.uuid == UUID(uuidString: "01020304-0506-0708-090a-0b0c0d0e0f10"))
    }
}


@Test func validateRoundStringDict1() throws {
    do {
        let dict1 = StringDict1()
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict1.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
    do {
        let dict1 = StringDict1(keys: ["a", "b", "c"], values: [.init(name: "max"), .init(name: "alex"), .init(name: "leo"), ])
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict1.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
}

@Test func validateRoundStringDict2() throws {
    do {
        let dict1 = StringDict2()
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict2.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
    do {
        let dict1 = StringDict2(keys: ["a", "b", "c"], values: [.init(name: "max"), .init(name: "alex"), .init(name: "leo"), ])
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict2.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
}

@Test func validateRoundStringDict3() throws {
    do {
        let dict1 = StringDict3()
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict3.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
    do {
        let dict1 = StringDict3(keys: ["a", "b", "c"], values: [.init(name: "max"), .init(name: "alex"), .init(name: "leo"), ])
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict3.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
}

@Test func validateRoundStringDict4() throws {
    do {
        let dict1 = StringDict4()
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict4.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
    do {
        let dict1 = StringDict4(keys: ["a", "b", "c"], values: [.init(name: "max"), .init(name: "alex"), .init(name: "leo"), ])
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict4.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
}

@Test func validateRoundStringDict5() throws {
    do {
        let dict1 = StringDict5()
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict5.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
    do {
        let dict1 = StringDict5(keys: ["a", "b", "c"], values: [.init(name: "max"), .init(name: "alex"), .init(name: "leo"), ])
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict5.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
}

@Test func validateRoundStringDict6() throws {
    do {
        let dict1 = StringDict6()
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict6.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
    do {
        let dict1 = StringDict6(keys: ["a", "b", "c"], values: [.init(name: "max"), .init(name: "alex"), .init(name: "leo"), ])
        let builder = DataBuilder()
        let offset = try dict1.apply(builder: builder)
        let data = builder.makeData
        let reader = DataReader(data: data)
        let dict2 = try StringDict6.with(reader: reader, offset: UInt64(data.count) - offset)
        #expect(dict1 == dict2)
    }
}
