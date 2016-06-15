//
//  MemoryStorage.swift
// Chameleon
//
//  Created by Ian Keen on 24/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public final class MemoryStorage: Storage {
    private var data = [String: [String: Any]]()
    
    public init() { }
    
    public func set<T>(_ in: StorageNamespace, key: String, value: T) {
        var data = self.data[`in`.namespace] ?? [:]
        data[key] = value
        self.data[`in`.namespace] = data
    }
    public func get<T>(_ in: StorageNamespace, key: String) -> T? {
        return self.data[`in`.namespace]?[key] as? T
    }
}
