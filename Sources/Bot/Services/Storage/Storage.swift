//
//  Storage.swift
//  Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

/// Defines a namespace to group different settings
public enum StorageNamespace {
    /// A namespace designed to store data that can be shared among services
    case shared
    
    /// A custom namespace to keep service specific data separate
    case `in`(String)
    
    public var namespace: String {
        switch self {
        case .shared: return "shared"
        case .in(let value): return value
        }
    }
}

/// Describes a range of errors that can occur when using storage
public enum StorageError: Error, CustomStringConvertible {
    /// The connection url supplied is invalid
    case invalidURL(url: String)
    
    /// The value being stored is invalid
    case invalidValue(value: Any)
    
    /// The value being stored is unsupported
    case unsupportedType(value: Any.Type)
    
    /// Something went wrong with an dependency
    case internalError(error: Error)
    
    public var description: String {
        switch self {
        case .invalidURL(let url):
            return "The url provided was invalid: \(url)"
        case .invalidValue(let value):
            return "The value supplied was invalid: \(value)"
        case .unsupportedType(let value):
            return "The type of value supplied was unsupported: \(String(value.self))"
        case .internalError(let error):
            let nestedDescription = (error as? CustomStringConvertible)?.description ?? String(error)
            return "Internal Error: \(nestedDescription)"
        }
    }
}

/// An abstraction representing an object capable of key/value storage
public protocol Storage: class {
    /**
     Assign a value to a key under a namespace
     
     - parameter type:  The `Type` of `value`
     - parameter in:    The `StorageNamespace` to store the key/value pair under
     - parameter key:   A unique key to store `value` under
     - parameter value: The value being stored
     - throws: A `StorageError` with failure details
     */
    func set<T: StorableType>(_ type: T.Type, in: StorageNamespace, key: String, value: T) throws
    
    /**
     Retrieves a value by its key under a namespace
     
     - parameter type: The `Type` of value being retrieved
     - parameter in:   The `StorageNamespace` the key/value pair is under
     - parameter key:  A unique key used to store the value
     - returns: returns the value if a value was found with the provided key under the namespace and the type matches `type`, otherwise nil
     */
    func get<T: StorableType>(_ type: T.Type, in: StorageNamespace, key: String) -> T?
}

public extension Storage {
    /**
     Assign a value to a key under a namespace
     
     - parameter in:    The `StorageNamespace` to store the key/value pair under
     - parameter key:   A unique key to store `value` under
     - parameter value: The value being stored
     - throws: A `StorageError` with failure details
     */
    public func set<T: StorableType>(_ in: StorageNamespace, key: String, value: T) throws {
        try self.set(T.self, in: `in`, key: key, value: value)
    }
    
    /**
     Retrieves a value by its key under a namespace
     
     - parameter in:   The `StorageNamespace` the key/value pair is under
     - parameter key:  A unique key used to store the value
     - returns: returns the value if a value was found with the provided key under the namespace and the type matches `T`, otherwise nil
     */
    public func get<T: StorableType>(_ in: StorageNamespace, key: String) -> T? {
        return self.get(T.self, in: `in`, key: key)
    }
    
    /**
     Retrieves a value by its key under a namespace
     
     - parameter type: The `Type` of value being retrieved
     - parameter in:   The `StorageNamespace` the key/value pair is under
     - parameter key:  A unique key used to store the value
     - parameter or:   The value to return if one does not exist or something goes wrong
     - returns: returns the value if a value was found with the provided key under the namespace and the type matches `type`, otherwise `or`
     */
    public func get<T: StorableType>(_ type: T.Type = T.self, in: StorageNamespace, key: String, or: T) -> T {
        return self.get(type, in: `in`, key: key) ?? or
    }
    
    /**
     Retrieves a value by its key under a namespace
     
     - parameter in:   The `StorageNamespace` the key/value pair is under
     - parameter key:  A unique key used to store the value
     - parameter or:   The value to return if one does not exist or something goes wrong
     - returns: returns the value if a value was found with the provided key under the namespace and the type matches `T`, otherwise `or`
     */
    public func get<T: StorableType>(_ in: StorageNamespace, key: String, or: T) -> T {
        return self.get(T.self, in: `in`, key: key, or: or)
    }
}

/// An abstraction representing an object capable being stored by a `Storage` object
public protocol StorableType {
    var storableValue: Any { get }
    func value<T>() -> T?
}
public extension StorableType {
    public var storableValue: Any { return self }
    public func value<T>() -> T? { return self as? T }
}
extension String: StorableType { }
extension Int: StorableType { }
extension Bool: StorableType { }
extension Array: StorableType { }
