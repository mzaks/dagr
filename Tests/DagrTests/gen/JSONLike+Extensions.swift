//
//  JSONLike+Extensions.swift
//  Dagr
//
//  Created by MacBookProMax on 07.10.25.
//

extension JSONLike.Value {
    var bool: Bool? {
        guard case .bool(let bool) = self else {
            return nil
        }
        return bool
    }
    var string: String? {
        guard case .string(let string) = self else {
            return nil
        }
        return string
    }
    var number: Double? {
        guard case .number(let number) = self else {
            return nil
        }
        return number
    }
    var array: [JSONLike.Value?]? {
        guard case .array(let array) = self else {
            return nil
        }
        return array
    }
    var dict: [String: JSONLike.Value]? {
        guard case .dict(let array) = self else {
            return nil
        }
        var result = [String: JSONLike.Value]()
        for p in array {
            if let v = p.value {
                result[p.key] = v
            }
        }
        return result
    }
    
    var count: Int {
        switch self {
        case .number, .bool:
            return 1
        case .string(let s):
            return s.count
        case .array(let a):
            return a.count
        case .dict(let a):
            return a.count
        }
    }
    
    mutating func append(_ value: JSONLike.Value) {
        guard case .array(var array) = self else {
            return
        }
        array.append(value)
        self = .array(array)
    }
    
    subscript(key: String) -> JSONLike.Value? {
        get {
            guard case .dict(let array) = self else {
                return nil
            }
            return array.first(where: {$0.key == key})?.value
        }
        set(newValue) {
            guard case .dict(var array) = self else {
                return
            }
            if let index = array.firstIndex(where: {$0.key == key}){
                array[index] = .init(key: key, value: newValue)
            } else {
                array.append(.init(key: key, value: newValue))
            }
            self = .dict(array)
        }
    }
    
    subscript(index: Int) -> JSONLike.Value? {
        get {
            guard case .array(let array) = self else {
                return nil
            }
            return array[index]
        }
        set(newValue) {
            guard case .array(var array) = self else {
                return
            }
            if index >= array.count {
                return
            }
            array[index] = newValue
            self = .array(array)
        }
    }
}

extension JSONLike.Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case .string(let string):
            let escapedString = string.replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "/", with: "\\/")
                .replacingOccurrences(of: "\n", with: "\\n")
                .replacingOccurrences(of: "\r", with: "\\r")
                .replacingOccurrences(of: "\t", with: "\\t")
            return #""\#(escapedString)""#
        case .bool(let bool):
            return "\(bool)"
        case .number(let number):
            return "\(number)"
        case .array(let array):
            return "[\(array.map{$0?.description ?? "null"}.joined(separator: ","))]"
        case .dict(let array):
            let tupples = array.map{#""\#($0.key ?? "")":\#($0.value?.description ?? "null")"#}.joined(separator: ",")
            return "{\(tupples)}"
        }
    }
}
