//
//  JSON+KeyPath.swift
//  Chameleon
//
//  Created by Ian Keen on 8/06/2016.
//
//

import Foundation

public extension Collection where Iterator.Element == (key: String, value: Any), Index == DictionaryIndex<String, Any> {
    /**
     Allows access to elements of a `JSON` object using a keypath/
     
     Example:
     
     ```
     let user: [String: Any] /* ["name": "Ian Keen", "contact_details": ["email": "email@domain.com"]] */
     let email: String = try user["contact_details.email"] // "email@domain.com"
     ```
     
     NOTE: currently does not support array index lookups.
     
     - parameter keyPath: The keypath to use
     - throws: A `KeyPathError` with failure details
     - returns: The retrieved value
     */
    public func keyPathValue<T>(_ keyPath: String) throws -> T {
        let keyPathComponents = keyPath.components(separatedBy: ".")
        return try self.keyPathValue(keyPath, keyPathComponents: keyPathComponents, object: self)
    }
    
    /**
     Determine if a provided keyPath exists within the given `[String: Any]`
    
     - parameter keyPath: The keyPath to test
     - returns: If the keyPath exists `true`, otherwise `false`
     */
    public func keyPathExists(_ keyPath: String) -> Bool {
        return self.keyPathExists(keyPath, type: Any.self)
    }
    
    /**
     Determine if a provided keyPath exists within the given `[String: Any]` and matches the specified `Type`
     
     - parameter keyPath: The keyPath to test
     - parameter type: The `Type` the found value must be
     - returns: If the keyPath exists and the types are valid `true`, otherwise `false`
     */
    public func keyPathExists<T>(_ keyPath: String, type: T.Type, predicate: (T) -> Bool = { _ in true }) -> Bool {
        let keyPathComponents = keyPath.components(separatedBy: ".")
        guard let last = keyPathComponents.last else { return false }
        
        var object = self as! [String: Any]
        for keyPath in keyPathComponents.dropLast() {
            guard let next = object[keyPath] as? [String: Any] else { return false }
            object = next
        }
        
        guard let value = object[last] as? T, predicate(value) else {
            return false
        }
        return true
    }
    
    //MARK: - Private
    private func keyPathValue<T>(_ keyPath: String, keyPathComponents: [String], object: Any) throws -> T {
        guard let dict = object as? [String: Any] else {
            throw KeyPathError.typeMismatch(keyPath: keyPath, expected: String([String: Any].self), got: String(object.dynamicType))
        }
        
        guard
            let key = keyPathComponents.first,
            !key.isEmpty && dict.keys.contains(key),
            let value = dict[key]
            else { throw KeyPathError.invalidKeyPath(keyPath: keyPath) }
        
        let isLast = (keyPathComponents.count == 1)
        
        if let jsonValue = value as? T {
            return jsonValue
            
        } else if let jsonValue = value as? [String: Any] {
            if (isLast) {
                throw KeyPathError.typeMismatch(keyPath: keyPath, expected: String(T.self), got: String(jsonValue.dynamicType))
            }
            let nestedKeyPathComponents = Array(keyPathComponents.dropFirst())
            return try self.keyPathValue(
                keyPath,
                keyPathComponents: nestedKeyPathComponents,
                object: value
            )
            
        } else {
            throw KeyPathError.typeMismatch(keyPath: keyPath, expected: String(T.self), got: String(value.dynamicType))
        }
    }
}

/**
 Describes a range of errors that can occur when attempting to access [String: Any] via a keypath
 */
public enum KeyPathError: Error, CustomStringConvertible {
    /// The provided keypath was not found
    case invalidKeyPath(keyPath: String)
    
    /// A value was found but the type requested was not the type that was found
    case typeMismatch(keyPath: String, expected: String, got: String)
    
    public var description: String {
        switch self {
        case .invalidKeyPath(let keyPath):
            return "Invalid keyPath provided: \(keyPath)"
        case .typeMismatch(let keyPath, let expected, let got):
            return "Type mismatch on keyPath: '\(keyPath)' - Expected: \(expected), got: \(got)"
        }
    }
}
