import Testing
@testable import Dagr

typealias Person1 = BuilderSamples.Person1
typealias Person2 = BuilderSamples.Person2
typealias Person3 = BuilderSamples.Person3
typealias MyDate = BuilderSamples.MyDate
typealias Person4 = BuilderSamples.Person4
typealias Person5 = BuilderSamples.Person5

@Test func example() throws {
    let builder = DataBuilder()

    _ = try builder.store(string: "Hello Maxim Zaks")
    _ = try builder.store(string: "Hello 😍")
    _ = try builder.storeAsLEB(value: 2000000451)
    #expect(builder.makeData.map{ $0 } == [195, 171, 214, 185, 7, 10, 72, 101, 108, 108, 111, 32, 240, 159, 152, 141, 16, 72, 101, 108, 108, 111, 32, 77, 97, 120, 105, 109, 32, 90, 97, 107, 115])
}

@Test func validatePerson1() throws {
    let builder = DataBuilder()
    let p1 = Person1(name:"Maxim", age: 41)

    _ = try p1.apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [4, 1, 2, 5, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try p1.apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [4, 7, 41, 4, 1, 2, 5, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person1(age: 20).apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [4, 0, 1, 5, 20, 4, 7, 41, 4, 1, 2, 5, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person1().apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [4, 0, 0, 5, 4, 0, 1, 5, 20, 4, 7, 41, 4, 1, 2, 5, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person1().apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [0, 4, 0, 0, 5, 4, 0, 1, 5, 20, 4, 7, 41, 4, 1, 2, 5, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person1().apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [2, 0, 4, 0, 0, 5, 4, 0, 1, 5, 20, 4, 7, 41, 4, 1, 2, 5, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person1(name:"Maxim").apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [4, 1, 0, 5, 20, 2, 0, 4, 0, 0, 5, 4, 0, 1, 5, 20, 4, 7, 41, 4, 1, 2, 5, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person1(name:"Alex").apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [12, 0, 4, 65, 108, 101, 120, 4, 1, 0, 5, 20, 2, 0, 4, 0, 0, 5, 4, 0, 1, 5, 20, 4, 7, 41, 4, 1, 2, 5, 1, 41, 5, 77, 97, 120, 105, 109])
}

@Test func validatePerson2() throws {
    let builder = DataBuilder()
    let p = Person2(name:"Maxim", age: 41)

    _ = try p.apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [3, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try p.apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [3, 4, 41, 3, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person2(age: 20).apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [2, 20, 3, 4, 41, 3, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person2().apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [0, 2, 20, 3, 4, 41, 3, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person2().apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [0, 0, 2, 20, 3, 4, 41, 3, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person2().apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [0, 0, 0, 2, 20, 3, 4, 41, 3, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person2(name:"Maxim").apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [1, 11, 0, 0, 0, 2, 20, 3, 4, 41, 3, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person2(name:"Alex").apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [1, 0, 4, 65, 108, 101, 120, 1, 11, 0, 0, 0, 2, 20, 3, 4, 41, 3, 1, 41, 5, 77, 97, 120, 105, 109])
}

@Test func validatePerson3() throws {
    let builder = DataBuilder()
    let p = Person3(name:"Maxim", age: 41)

    _ = try p.apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [4, 0, 0, 1, 1, 9, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try p.apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [4, 9, 41, 4, 0, 0, 1, 1, 9, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person3(age: 20).apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [2, 1, 0, 5, 20, 4, 9, 41, 4, 0, 0, 1, 1, 9, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person3().apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [0, 0, 2, 1, 0, 5, 20, 4, 9, 41, 4, 0, 0, 1, 1, 9, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person3().apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [0, 0, 0, 2, 1, 0, 5, 20, 4, 9, 41, 4, 0, 0, 1, 1, 9, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person3().apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [2, 0, 0, 0, 2, 1, 0, 5, 20, 4, 9, 41, 4, 0, 0, 1, 1, 9, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person3(name:"Maxim").apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [2, 0, 0, 5, 20, 2, 0, 0, 0, 2, 1, 0, 5, 20, 4, 9, 41, 4, 0, 0, 1, 1, 9, 1, 41, 5, 77, 97, 120, 105, 109])

    _ = try Person3(name:"Alex").apply(builder: builder)
    #expect(builder.makeData.map{ $0 } == [12, 0, 4, 65, 108, 101, 120, 2, 0, 0, 5, 20, 2, 0, 0, 0, 2, 1, 0, 5, 20, 4, 9, 41, 4, 0, 0, 1, 1, 9, 1, 41, 5, 77, 97, 120, 105, 109])
}

@Test func validateMyDate() throws {
    let builder = DataBuilder()
    _ = try builder.store(structNode: MyDate(day: 11, month: 1, year: 1981))
    #expect(builder.makeData.map{ $0 } == [11, 1, 189, 7])
}

@Test func validatePerson4() throws {
    let builder = DataBuilder()
    let p0 = Person4()
    _ = try builder.store(structNode: p0)
    #expect(builder.makeData.map{$0} == [6, 0, 0, 0, 7])
    let p1 = Person4()
    _ = try builder.store(structNode: p1)
    #expect(builder.makeData.map{$0} == [0, 6, 0, 0, 0, 7])
    let d1 = MyDate(day: 11, month: 1, year: 1981)
    let p2 = Person4(name: "Maxim", age: 41, date: d1)
    _ = try builder.store(structNode: p2)
    #expect(builder.makeData.map{$0} == [6, 1, 2, 3, 7, 6, 41, 0, 11, 1, 189, 7, 5, 77, 97, 120, 105, 109, 0, 6, 0, 0, 0, 7])
    let p3 = Person4(name: "Maxim", age: 41, date: d1)
    _ = try builder.store(structNode: p3)
    #expect(builder.makeData.map{$0} == [6, 14, 41, 16, 6, 1, 2, 3, 7, 6, 41, 0, 11, 1, 189, 7, 5, 77, 97, 120, 105, 109, 0, 6, 0, 0, 0, 7])
}

@Test func validatePerson5() throws {
    let builder = DataBuilder()
    let d1 = MyDate(day: 11, month: 1, year: 1981)
    let d2 = MyDate(day: 11, month: 1, year: 1995)
    let p1 = Person5(name: "Maxim", age: 41, date: d1)
    let p2 = Person5(name: "Alex", age: 27, date: d2)

    p1.friend = p2
    _ = try builder.store(structNode: p1)

    #expect(builder.makeData.map{$0} == [8, 1, 2, 3, 4, 9, 25, 41, 38, 10, 8, 1, 2, 3, 0, 9, 6, 27, 0, 11, 1, 203, 7, 4, 65, 108, 101, 120, 11, 1, 189, 7, 5, 77, 97, 120, 105, 109])
}

@Test func validatePerson5WithCycle() throws {
    let builder = DataBuilder()
    let d1 = MyDate(day: 11, month: 1, year: 1981)
    let p1 = Person5(name: "Maxim", age: 41, date: d1)

    p1.friend = p1
    _ = try builder.store(structNode: p1)

    #expect(builder.makeData.map{$0} == [8, 1, 2, 3, 4, 9, 11, 41, 10, 7, 0, 0, 0, 0, 11, 1, 189, 7, 5, 77, 97, 120, 105, 109])
}

@Test func validateBitSet() throws {
    let builder = DataBuilder()
    _ = try builder.store(bools: [true, true, false, false, false, true])
    #expect(builder.makeData.map{$0} == [6, 0b00100011])
}

@Test func validateBoolWithNil() throws {
    let builder = DataBuilder()
    _ = try builder.storeWithOptionals(bools: [true, true, nil, false, false, true])
    #expect(builder.makeData.map{$0} == [6, 0b00111011, 0b00100011])
}

@Test func validateI8Array() throws {
    let builder = DataBuilder()
    _ = try builder.store(numbers: [Int8(-13), Int8(56), Int8(78)])
    #expect(builder.makeData.map{$0} == [3, 243, 56, 78])
}

@Test func validateI16Array() throws {
    let builder = DataBuilder()
    _ = try builder.store(numbers: [Int16(-13), Int16(56), Int16(378)])
    #expect(builder.makeData.map{$0} == [3, 243, 255, 56, 0, 122, 1])
}

@Test func validateF16Array() throws {
    let builder = DataBuilder()
    _ = try builder.store(numbers: [Float16(-13), Float16(56), Float16(37.8)])
    #expect(builder.makeData.map{$0} == [3, 128, 202, 0, 83, 186, 80])
}

@Test func validateF32Array() throws {
    let builder = DataBuilder()
    _ = try builder.store(numbers: [Float32(-13), Float32(56), Float32(37.8)])
    #expect(builder.makeData.map{$0} == [3, 0, 0, 80, 193, 0, 0, 96, 66, 51, 51, 23, 66])
}

@Test func validateF32ArrayWithNil() throws {
    let builder = DataBuilder()
    _ = try builder.storeWithOptionals(numbers: [Float32(-13), Float32(56), Float32(37.8)])
    #expect(builder.makeData.map{$0} == [3, 0b00000111, 0, 0, 80, 193, 0, 0, 96, 66, 51, 51, 23, 66])
}

@Test func validateStringArray() throws {
    let builder = DataBuilder()
    _ = try builder.store(strings: ["hello", "world", "hello", "abc"])
    #expect(builder.makeData.map{$0} == [16, 7, 1, 7, 13, 5, 119, 111, 114, 108, 100, 5, 104, 101, 108, 108, 111, 3, 97, 98, 99])
}

@Test func validateStringArrayWithNil() throws {
    let builder = DataBuilder()
    _ = try builder.store(strings: ["hello", "world", nil, "abc"])
    #expect(builder.makeData.map{$0} == [16, 1, 7, 0, 13, 5, 104, 101, 108, 108, 111, 5, 119, 111, 114, 108, 100, 3, 97, 98, 99])
}

@Test func validateTwoBitArray() throws {
    let builder = DataBuilder()
    _ = try builder.store(twoBitArray: [1, 2, 3, 0, 1, 3])
    #expect(builder.makeData.map{$0} == [6, 0b00111001, 0b00001101])
}

@Test func validateFourBitArray() throws {
    let builder = DataBuilder()
    _ = try builder.store(fourBitArray: [1, 2, 3, 0, 1, 3])
    #expect(builder.makeData.map{$0} == [6, 0b00100001, 0b00000011, 0b00110001])
}
