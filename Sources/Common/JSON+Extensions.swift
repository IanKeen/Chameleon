//
//  JSON+Extensions.swift
//  Slack
//
//  Created by Ian Keen on 8/06/2016.
//
//

import Foundation
import Jay

public enum JSONError: ErrorProtocol {
    case InvalidKeyPath(keyPath: String)
    case TypeMismatch(keyPath: String, expected: String, got: String)
}

public extension JSON {
    public func keyPathValue<T>(_ keyPath: String) throws -> T {
        let keyPathComponents = keyPath.components(separatedBy: ".")
        return try self.keyPathValue(keyPath, keyPathComponents: keyPathComponents, json: self)
    }
    private func keyPathValue<T>(_ keyPath: String, keyPathComponents: [String], json: JSON) throws -> T {
        guard let dict = json.dictionary
            else { throw JSONError.TypeMismatch(keyPath: keyPath, expected: String([String: JSON]), got: json.jsonTypeDescription) }
        
        guard
            let key = keyPathComponents.first
            where !key.isEmpty && dict.keys.contains(key),
            let value = dict[key]
            else { throw JSONError.InvalidKeyPath(keyPath: keyPath) }
        
        let isLast = (keyPathComponents.count == 1)
        
        if let jsonValue = value.tryGet(type: T.self) {
            return jsonValue
            
        } else if let jsonValue = value.dictionary {
            if (isLast) {
                throw JSONError.TypeMismatch(keyPath: keyPath, expected: String(T), got: String(jsonValue.dynamicType))
            }
            let nestedKeyPathComponents = Array(keyPathComponents.dropFirst())
            return try self.keyPathValue(
                keyPath,
                keyPathComponents: nestedKeyPathComponents,
                json: value
            )
            
        } else {
            throw JSONError.TypeMismatch(keyPath: keyPath, expected: String(T), got: String(value.jsonTypeDescription))
        }
    }
    private func tryGet<T>(type: T.Type) -> T? {
        switch self {
        case .null:
            return nil
        case .boolean(let value):
            return value as? T
        case .number:
            return self.tryNumber(json: self, type: type)
        case .string(let value):
            return value as? T
        case .array(let value):
            return value as? T
        case .object(let value):
            return value as? T
        }
    }
    private func tryNumber<T>(json: JSON, type: T.Type) -> T? {
        guard case .number(let value) = json else { return nil }
        
        switch value {
        case .double(let value):
            switch type {
            case is Int.Type: return Int(value) as? T
            case is Double.Type: return Double(value) as? T
            case is Float.Type: return Float(value) as? T
            default: return value as? T
            }
        case .integer(let value):
            switch type {
            case is Int.Type: return Int(value) as? T
            case is Double.Type: return Double(value) as? T
            case is Float.Type: return Float(value) as? T
            default: return value as? T
            }
        case .unsignedInteger(let value):
            switch type {
            case is Int.Type: return Int(value) as? T
            case is Double.Type: return Double(value) as? T
            case is Float.Type: return Float(value) as? T
            default: return value as? T
            }
        }
    }
}

extension JSON {
    public subscript(index: Int) -> JSON? {
        get {
            switch self {
            case .array(let array):
                return index < array.count ? array[index] : nil
            default: return nil
            }
        }
        
        set(json) {
            switch self {
            case .array(let array):
                var array = array
                if index < array.count {
                    if let json = json {
                        array[index] = json
                    } else {
                        array[index] = .null
                    }
                    self = .array(array)
                }
            default: break
            }
        }
    }
    
    public subscript(key: String) -> JSON? {
        get {
            switch self {
            case .object(let object):
                return object[key]
            default: return nil
            }
        }
        
        set(json) {
            switch self {
            case .object(let object):
                var object = object
                object[key] = json
                self = .object(object)
            default: break
            }
        }
    }
}

extension JSON {
    public var jsonTypeDescription: String {
        return String(self)
    }
    public var jsonValueDescription: String {
        switch self {
        case .null:
            return "null"
        case .boolean(let value):
            return (value ? "true" : "false")
        case .number(let number):
            switch number {
            case .double(let value):
                return "\(value)"
            case .integer(let value):
                return "\(value)"
            case .unsignedInteger(let value):
                return "\(value)"
            }
        case .string(let value):
            return value
            
        case .array(let value):
            let items = value
                .map { $0.jsonValueDescription }
                .joined(separator: ",")
            return "[\(items)]"
            
        case .object(let value):
            let items = value
                .map { key, value in
                    return "\(key): \(value.jsonValueDescription)"
                }
                .joined(separator: ",")
            return "{\(items)}"
        }
    }
}
