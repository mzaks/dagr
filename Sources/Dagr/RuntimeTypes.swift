//
//  RuntimeTypes.swift
//  
//
//  Created by Maxim Zaks on 01.12.22.
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

public enum ByteWidth {
    case eighth, quarter, half, one, two, four, eight

    static func with(value: UInt64) -> ByteWidth {
        if value <= UInt8.max {
            return .one
        }
        if value <= UInt16.max {
            return .two
        }
        if value <= UInt32.max {
            return .four
        }
        return .eight
    }
}

public protocol Node: AnyObject {
    func apply(builder: Builder) throws -> UInt64
    init()
    static func with<T: Reader>(reader: T, offset: UInt64) throws -> Self
}

public protocol EnumNode {
    var value: UInt64 {get}
    static var byteWidth: ByteWidth {get}
    static func from(value: UInt64) -> Self?
}

public enum AppliedUnionType {
    case value(value: UInt64, id: UInt64), pointer(value: UInt64, id: UInt64), bidirPointer(value: UInt64, id: UInt64), reservedPointer(value: ObjectIdentifier, id: UInt64)
}

public protocol UnionNode {
    func apply(builder: Builder) throws -> AppliedUnionType
    var typeId: UInt64 {get}
    static var byteWidth: ByteWidth {get}
    static func from<T: Reader>(typeId: UInt64, value: UInt64, reader: T, offset: UInt64) throws -> Self?
}

public struct ObjectIdentifierPair: Equatable, Hashable {
    let left: ObjectIdentifier
    let right: ObjectIdentifier
    public init(left: ObjectIdentifier, right: ObjectIdentifier) {
        self.left = left
        self.right = right
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Self { self }
}

extension Array where Element: OptionalType, Element.Wrapped: CycleAwareEquatable {
    public func cycleAwareEquality(other: Self, visited: inout Set<ObjectIdentifierPair>) -> Bool {
        guard self.count == other.count else {
            return false
        }

        for index in 0..<self.count {
            if let left = self[index].optional {
                if let right = other[index].optional {
                    if left.cycleAwareEquality(other: right, visited: &visited) == false {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                if other[index].optional != nil {
                    return false
                }
            }
        }
        return true
    }
}

extension Array where Element: CycleAwareEquatable {
    public func cycleAwareEquality(other: Self, visited: inout Set<ObjectIdentifierPair>) -> Bool {
        guard self.count == other.count else {
            return false
        }

        for index in 0..<self.count {
            if self[index].cycleAwareEquality(other: other[index], visited: &visited) == false {
                return false
            }
        }
        return true
    }
}

extension Array where Element: CycleAwareHashable {
    public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
        for value in self {
            value.hash(into: &hasher, visited: &visited)
        }
    }
}

extension Array where Element: OptionalType, Element.Wrapped: CycleAwareHashable {
    public func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>) {
        for value in self {
            if let wrapped = value.optional {
                wrapped.hash(into: &hasher, visited: &visited)
            }
        }
    }
}

public protocol CycleAwareEquatable: Equatable {
    func cycleAwareEquality(other: Self, visited: inout Set<ObjectIdentifierPair>) -> Bool
}

extension CycleAwareEquatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        var visited = Set<ObjectIdentifierPair>()
        return lhs.cycleAwareEquality(other: rhs, visited: &visited)
    }
}

public protocol CycleAwareHashable: Hashable {
    func hash(into hasher: inout Hasher, visited: inout Set<ObjectIdentifier>)
}

extension CycleAwareHashable {
    public func hash(into hasher: inout Hasher) {
        var visited = Set<ObjectIdentifier>()
        self.hash(into: &hasher, visited: &visited)
    }
}

extension Int64 {
    public var toZigZag: UInt64 {
        return UInt64(bitPattern: (self >> 63) ^ (self << 1))
    }
}

extension UInt64 {
    public var toZigZag: UInt64 {
        self << 1
    }

    public var toNegativZigZag: UInt64 {
        (self << 1) - 1
    }
}

extension UInt64 {
    public var fromZigZag: Int64 {
        Int64(self >> 1) ^ -Int64((self & 1))
    }
}

extension Array where Element == Bool {
    public var bitSet: [UInt8] {
        var result = [UInt8]()
        for (index, v) in self.enumerated() {
            if index & 7 == 0 {
                result.append(v ? 1 : 0)
            } else if v {
                result[index >> 3] |= v ? 1 << (index & 7) : 0
            }
        }
        return result
    }
}
