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
