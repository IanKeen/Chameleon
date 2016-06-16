//
//  Storage.swift
// Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public enum StorageNamespace {
    case Shared
    case In(String)
    
    var namespace: String {
        switch self {
        case .Shared: return "shared"
        case .In(let value): return value
        }
    }
}

/// Describes a range of errors that can occur when using storage
public enum StorageError: ErrorProtocol {
    /// The value being stored is invalid
    case invalidValue(value: Any)
    
    /// The value being stored is unsupported
    case unsupportedType(value: Any.Type)
    
    /// Something went wrong with an dependency
    case internalError(error: ErrorProtocol)
}

public protocol Storage: class {
    func set<T: StorableType>(type: T.Type, in: StorageNamespace, key: String, value: T) throws
    func get<T: StorableType>(type: T.Type, in: StorageNamespace, key: String) -> T?
}

extension Storage {
    public func set<T: StorableType>(_ in: StorageNamespace, key: String, value: T) throws {
        try self.set(type: T.self, in: `in`, key: key, value: value)
    }
    public func get<T: StorableType>(_ in: StorageNamespace, key: String) -> T? {
        return self.get(type: T.self, in: `in`, key: key)
    }
    public func get<T: StorableType>(type: T.Type = T.self, in: StorageNamespace, key: String, or: T) -> T {
        return self.get(type: type, in: `in`, key: key) ?? or
    }
    public func get<T: StorableType>(_ in: StorageNamespace, key: String, or: T) -> T {
        return self.get(type: T.self, in: `in`, key: key, or: or)
    }
}

public protocol StorableType {
    var storableValue: Any { get }
    func value<T>() -> T?
}
extension StorableType {
    public var storableValue: Any { return self }
    public func value<T>() -> T? { return self as? T }
}
extension String: StorableType { }
extension Int: StorableType { }
extension Bool: StorableType { }
extension Array: StorableType { }