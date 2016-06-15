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

public protocol Storage: class {
    func set<T>(_ in: StorageNamespace, key: String, value: T) //TODO: should this be a throwing function...?
    func get<T>(_ in: StorageNamespace, key: String) -> T?
    func get<T>(_ in: StorageNamespace, key: String, or: T) -> T
}

extension Storage {
    public func get<T>(_ in: StorageNamespace, key: String, or: T) -> T {
        return self.get(`in`, key: key) ?? or
    }
}
