//
//  JSON+KeyPath.swift
//  Chameleon
//
//  Created by Ian Keen on 8/06/2016.
//
//

import Foundation

public extension JSON {
    /**
     Allows access to elements of a `JSON` object using a keypath/
     
     Example:
     
     ```
     let user: JSON /* ["name": "Ian Keen", "contact_details": ["email": "email@domain.com"]] */
     let email: String = try user["contact_details.email"] // "email@domain.com"
     ```
     
     NOTE: currently does not support array index lookups.
     
     - parameter keyPath: The keypath to use
     - throws: A `JSON.Error` with failure details
     - returns: The retrieved value
     */
    public func keyPathValue<T>(_ keyPath: String) throws -> T {
        let keyPathComponents = keyPath.components(separatedBy: ".")
        return try self.keyPathValue(keyPath, keyPathComponents: keyPathComponents, json: self)
    }
    
    /**
     Determine if a provided keyPath exists within the given `JSON`
    
     - parameter keyPath: The keyPath to test
     - returns: If the keyPath exists `true`, otherwise `false`
     */
    public func keyPathExists(_ keyPath: String) -> Bool {
        let keyPathComponents = keyPath.components(separatedBy: ".")
        
        var json = self
        for keyPath in keyPathComponents {
            guard let next: JSON = json[keyPath] else { return false }
            json = next
        }
        return true
    }
    
    /**
     Determine if a provided keyPath exists within the given `JSON` and matches the specified `Type`
     
     - parameter keyPath: The keyPath to test
     - parameter type: The `Type` the found value must be
     - returns: If the keyPath exists and the types are valid `true`, otherwise `false`
     */
    public func keyPathExists<T>(_ keyPath: String, type: T.Type, predicate: (T) -> Bool = { _ in true }) -> Bool {
        let keyPathComponents = keyPath.components(separatedBy: ".")
        
        var json = self
        for keyPath in keyPathComponents {
            guard let next: JSON = json[keyPath] else { return false }
            json = next
        }
        
        guard let value: T = json.tryGet(type: type) where predicate(value) else {
            return false
        }
        return true
    }
    
    //MARK: - Private
    private func keyPathValue<T>(_ keyPath: String, keyPathComponents: [String], json: JSON) throws -> T {
        guard let dict = json.dictionary
            else { throw Error.typeMismatch(keyPath: keyPath, expected: String([String: JSON].self), got: json.jsonTypeDescription) }
        
        guard
            let key = keyPathComponents.first
            where !key.isEmpty && dict.keys.contains(key),
            let value = dict[key]
            else { throw Error.invalidKeyPath(keyPath: keyPath) }
        
        let isLast = (keyPathComponents.count == 1)
        
        if let jsonValue = value.tryGet(type: T.self) {
            return jsonValue
            
        } else if let jsonValue = value.dictionary {
            if (isLast) {
                throw Error.typeMismatch(keyPath: keyPath, expected: String(T.self), got: String(jsonValue.dynamicType))
            }
            let nestedKeyPathComponents = Array(keyPathComponents.dropFirst())
            return try self.keyPathValue(
                keyPath,
                keyPathComponents: nestedKeyPathComponents,
                json: value
            )
            
        } else {
            throw Error.typeMismatch(keyPath: keyPath, expected: String(T.self), got: String(value.jsonTypeDescription))
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

public extension JSON {
    /**
     Describes a range of errors that can occur when attempting to access JSON via a keypath
     */
    public enum Error: ErrorProtocol, CustomStringConvertible {
        /// The provided keypath was not found
        case invalidKeyPath(keyPath: String)
        
        /// A value was found but the type requested was not the type that was found
        case typeMismatch(keyPath: String, expected: String, got: String)
        
        public var description: String {
            switch self {
            case .invalidKeyPath(let keyPath):
                return "Invalid keyPath provided: \(keyPath)"
            case .typeMismatch(let keyPath, let expected, let got):
                return "Type mismatch on keyPath: \(keyPath) - Expected: \(expected), got: \(got)"
            }
        }
    }
}
