//  Generated with Dagr on 07.10.25.
//  https://github.com/mzaks/dagr
//

import Dagr
import Foundation

public enum FoundationNode {
    public static func encode(root: Bool) throws -> Data {
        let builder = DataBuilder()
        _ = try builder.store(number: root ? UInt8(1): UInt8(0))
        return builder.makeData
    }

    public static func decode(data: Data) throws -> Bool {
        let reader = DataReader(data: data)
        return try reader.readBool()
    }

    public final class UUID: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var a: UInt8! = nil
        public var b: UInt8! = nil
        public var c: UInt8! = nil
        public var d: UInt8! = nil
        public var e: UInt8! = nil
        public var f: UInt8! = nil
        public var g: UInt8! = nil
        public var h: UInt8! = nil
        public var i: UInt8! = nil
        public var j: UInt8! = nil
        public var k: UInt8! = nil
        public var l: UInt8! = nil
        public var m: UInt8! = nil
        public var n: UInt8! = nil
        public var o: UInt8! = nil
        public var p: UInt8! = nil

        public init() {}

        public init(a: UInt8, b: UInt8, c: UInt8, d: UInt8, e: UInt8, f: UInt8, g: UInt8, h: UInt8, i: UInt8, j: UInt8, k: UInt8, l: UInt8, m: UInt8, n: UInt8, o: UInt8, p: UInt8) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.e = e
            self.f = f
            self.g = g
            self.h = h
            self.i = i
            self.j = j
            self.k = k
            self.l = l
            self.m = m
            self.n = n
            self.o = o
            self.p = p
        }




        public func apply(builder: Builder) throws -> UInt64 {

            _ = try builder.store(number: p)
            _ = try builder.store(number: o)
            _ = try builder.store(number: n)
            _ = try builder.store(number: m)
            _ = try builder.store(number: l)
            _ = try builder.store(number: k)
            _ = try builder.store(number: j)
            _ = try builder.store(number: i)
            _ = try builder.store(number: h)
            _ = try builder.store(number: g)
            _ = try builder.store(number: f)
            _ = try builder.store(number: e)
            _ = try builder.store(number: d)
            _ = try builder.store(number: c)
            _ = try builder.store(number: b)
            _ = try builder.store(number: a)

            return builder.cursor

        }


        public func cycleAwareEquality(other: UUID, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.a == other.a
                && self.b == other.b
                && self.c == other.c
                && self.d == other.d
                && self.e == other.e
                && self.f == other.f
                && self.g == other.g
                && self.h == other.h
                && self.i == other.i
                && self.j == other.j
                && self.k == other.k
                && self.l == other.l
                && self.m == other.m
                && self.n == other.n
                && self.o == other.o
                && self.p == other.p

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(a)
            hasher.combine(b)
            hasher.combine(c)
            hasher.combine(d)
            hasher.combine(e)
            hasher.combine(f)
            hasher.combine(g)
            hasher.combine(h)
            hasher.combine(i)
            hasher.combine(j)
            hasher.combine(k)
            hasher.combine(l)
            hasher.combine(m)
            hasher.combine(n)
            hasher.combine(o)
            hasher.combine(p)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> UUID {
            var result: UUID
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            do {
                result.a = try reader.readAndSeekNumeric()
            }
            do {
                result.b = try reader.readAndSeekNumeric()
            }
            do {
                result.c = try reader.readAndSeekNumeric()
            }
            do {
                result.d = try reader.readAndSeekNumeric()
            }
            do {
                result.e = try reader.readAndSeekNumeric()
            }
            do {
                result.f = try reader.readAndSeekNumeric()
            }
            do {
                result.g = try reader.readAndSeekNumeric()
            }
            do {
                result.h = try reader.readAndSeekNumeric()
            }
            do {
                result.i = try reader.readAndSeekNumeric()
            }
            do {
                result.j = try reader.readAndSeekNumeric()
            }
            do {
                result.k = try reader.readAndSeekNumeric()
            }
            do {
                result.l = try reader.readAndSeekNumeric()
            }
            do {
                result.m = try reader.readAndSeekNumeric()
            }
            do {
                result.n = try reader.readAndSeekNumeric()
            }
            do {
                result.o = try reader.readAndSeekNumeric()
            }
            do {
                result.p = try reader.readAndSeekNumeric()
            }

            return result
        }

    }

    public final class UTCTimestamp: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var value: Float64! = nil

        public init() {}

        public init(value: Float64) {
            self.value = value
        }




        public func apply(builder: Builder) throws -> UInt64 {

            _ = try builder.store(number: value)

            return builder.cursor

        }


        public func cycleAwareEquality(other: UTCTimestamp, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.value == other.value

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(value)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> UTCTimestamp {
            var result: UTCTimestamp
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            do {
                result.value = try reader.readAndSeekNumeric()
            }

            return result
        }

    }

    public final class URL: Node, Equatable, CycleAwareEquatable, CycleAwareHashable {

        public var scheme: String? = nil
        public var user: String? = nil
        public var password: String? = nil
        public var host: String? = nil
        public var port: UInt16? = nil
        public var path: String? = nil
        public var query: String? = nil
        public var fragment: String? = nil

        public init() {}

        public init(scheme: String? = nil, user: String? = nil, password: String? = nil, host: String? = nil, port: UInt16? = nil, path: String? = nil, query: String? = nil, fragment: String? = nil) {
            self.scheme = scheme
            self.user = user
            self.password = password
            self.host = host
            self.port = port
            self.path = path
            self.query = query
            self.fragment = fragment
        }




        public func apply(builder: Builder) throws -> UInt64 {
            let schemePointer = try scheme.map { try builder.store(string: $0) }
            let userPointer = try user.map { try builder.store(string: $0) }
            let passwordPointer = try password.map { try builder.store(string: $0) }
            let hostPointer = try host.map { try builder.store(string: $0) }
            let pathPointer = try path.map { try builder.store(string: $0) }
            let queryPointer = try query.map { try builder.store(string: $0) }
            let fragmentPointer = try fragment.map { try builder.store(string: $0) }

            _ = try builder.storeForwardPointer(value: fragmentPointer)
            _ = try builder.storeForwardPointer(value: queryPointer)
            _ = try builder.storeForwardPointer(value: pathPointer)
            _ = try port.map { try builder.store(number: $0) }
            _ = try builder.storeForwardPointer(value: hostPointer)
            _ = try builder.storeForwardPointer(value: passwordPointer)
            _ = try builder.storeForwardPointer(value: userPointer)
            _ = try builder.storeForwardPointer(value: schemePointer)

            return try builder.store(inline: [scheme != nil, user != nil, password != nil, host != nil, port != nil, path != nil, query != nil, fragment != nil].bitSet)

        }


        public func cycleAwareEquality(other: URL, visited: inout Set<ObjectIdentifierPair>) -> Bool {
            let objectIdentifierPair = ObjectIdentifierPair(left: ObjectIdentifier(self), right: ObjectIdentifier(other))
            guard visited.contains(objectIdentifierPair) == false else {
                return true
            }
            visited.insert(objectIdentifierPair)

            return self.scheme == other.scheme
                && self.user == other.user
                && self.password == other.password
                && self.host == other.host
                && self.port == other.port
                && self.path == other.path
                && self.query == other.query
                && self.fragment == other.fragment

        }


        public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
            let objectIdentifier = ObjectIdentifier(self)
            guard visited.contains(objectIdentifier) == false else {
                return
            }
            visited.insert(objectIdentifier)
            hasher.combine(scheme)
            hasher.combine(user)
            hasher.combine(password)
            hasher.combine(host)
            hasher.combine(port)
            hasher.combine(path)
            hasher.combine(query)
            hasher.combine(fragment)

        }


        public static func with<T: Reader>(reader: T, offset: UInt64) throws -> URL {
            var result: URL
            let allSet: Bool
            (result, allSet) = try reader.getStructNode(from: offset)
            if allSet {
                return result
            }
            try reader.seek(to: offset)
            let optionalFields = try reader.readAndSeekBoolArrayWithLength(length: 8)
            if optionalFields[0] {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.scheme = try reader.readSting()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[1] {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.user = try reader.readSting()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[2] {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.password = try reader.readSting()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[3] {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.host = try reader.readSting()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[4] {
                result.port = try reader.readAndSeekNumeric()
            }
            if optionalFields[5] {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.path = try reader.readSting()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[6] {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.query = try reader.readSting()
                try reader.seek(to: currentCursor)
            }
            if optionalFields[7] {
                let stringPointer = try reader.readAndSeekLEB()
                let currentCursor = reader.cursor
                try reader.seek(by: Int64(stringPointer))
                result.fragment = try reader.readSting()
                try reader.seek(to: currentCursor)
            }

            return result
        }

    }

}