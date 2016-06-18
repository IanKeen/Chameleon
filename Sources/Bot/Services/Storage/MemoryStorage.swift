//
//  MemoryStorage.swift
//  Chameleon
//
//  Created by Ian Keen on 24/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

/// Provides in-memory only storage of key/value pairs
public final class MemoryStorage: Storage {
    //MARK: - Private
    private var data = [String: [String: Any]]()
    
    //MARK - Lifecycle
    public init() { }
    
    //MARK: - Storage
    public func set<T: StorableType>(type: T.Type, in: StorageNamespace, key: String, value: T) throws {
        var data = self.data[`in`.namespace] ?? [:]
        data[key] = value
        self.data[`in`.namespace] = data
    }
    public func get<T: StorableType>(type: T.Type, in: StorageNamespace, key: String) -> T? {
        return self.data[`in`.namespace]?[key] as? T
    }
}
