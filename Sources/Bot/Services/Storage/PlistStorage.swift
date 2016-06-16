//
//  PlistStorage.swift
// Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation

// Provides Plist based storage of key/value pairs (OSX only)
public final class PlistStorage: Storage {
    //MARK: - Public
    public init() { }
    
    //MARK: - Storage
    public func set<T: StorableType>(type: T.Type, in: StorageNamespace, key: String, value: T) throws {
        var dataset = self.dataset()
        var data = dataset[`in`.namespace] ?? [:]
        
        guard let anyObject = value.anyObject else { throw StorageError.invalidValue(value: value) }
        data[key] = anyObject
        dataset[`in`.namespace] = data
        
        self.saveDataset(dataset)
    }
    public func get<T : StorableType>(type: T.Type, in: StorageNamespace, key: String) -> T? {
        var dataset = self.dataset()
        var data = dataset[`in`.namespace] ?? [:]
        return data[key] as? T
    }
    
    //MARK: - Private
    private var fileName: String {
        return "\(NSHomeDirectory())/storage.plist"
    }
    private func dataset() -> [String: [String: AnyObject]] {
        guard let dict = NSDictionary(contentsOfFile: self.fileName) as? [String: [String: AnyObject]] else {
            return self.defaultDataset()
        }
        return dict
    }
    private func defaultDataset() -> [String: [String: AnyObject]] { return [:] }
    private func saveDataset(_ dataset: [String: [String: AnyObject]]) {
        (dataset as NSDictionary).write(toFile: self.fileName, atomically: true)
    }
}

//MARK: - Helper
extension StorableType {
    var anyObject: AnyObject? {
        return self as? AnyObject
    }
}
