//
//  JSON+KeyPath.swift
// Chameleon
//
//  Created by Ian Keen on 8/06/2016.
//
//

import Foundation
import Jay

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
    
    //MARK: - Private
    private func keyPathValue<T>(_ keyPath: String, keyPathComponents: [String], json: JSON) throws -> T {
        guard let dict = json.dictionary
            else { throw Error.typeMismatch(keyPath: keyPath, expected: String([String: JSON]), got: json.jsonTypeDescription) }
        
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
                throw Error.typeMismatch(keyPath: keyPath, expected: String(T), got: String(jsonValue.dynamicType))
            }
            let nestedKeyPathComponents = Array(keyPathComponents.dropFirst())
            return try self.keyPathValue(
                keyPath,
                keyPathComponents: nestedKeyPathComponents,
                json: value
            )
            
        } else {
            throw Error.typeMismatch(keyPath: keyPath, expected: String(T), got: String(value.jsonTypeDescription))
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
    /**
     Describes a range of errors that can occur when attempting to access JSON via a keypath
     */
    public enum Error: ErrorProtocol {
        /// The provided keypath was not found
        case invalidKeyPath(keyPath: String)
        
        /// A value was found but the type requested was not the type that was found
        case typeMismatch(keyPath: String, expected: String, got: String)
    }
}
