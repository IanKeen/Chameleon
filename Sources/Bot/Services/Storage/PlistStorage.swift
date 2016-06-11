////
////  PlistStorage.swift
////  Slack
////
////  Created by Ian Keen on 23/05/2016.
////  Copyright © 2016 Mustard. All rights reserved.
////
//
//public final class PlistStorage: Storage {
//    //MARK: - Public
//    public init() { }
//    
//    public func set<T : StorableDataType>(_ in: StorageNamespace, key: String, value: T) {
//        var dataset = self.dataset()
//        var data = dataset[`in`.namespace] ?? [:]
//        
//        data[key] = value.anyObject
//        dataset[`in`.namespace] = data
//        
//        self.saveDataset(dataset)
//    }
//    public func get<T>(_ in: StorageNamespace, key: String) -> T? {
//        var dataset = self.dataset()
//        var data = dataset[`in`.namespace] ?? [:]
//        return data[key] as? T
//    }
//    
//    //MARK: - Private
//    private var fileName: String {
//        return "\(NSHomeDirectory())/storage.plist"
//    }
//    private func dataset() -> [String: [String: Any]] {
//        guard let dict = NSDictionary(contentsOfFile: self.fileName) as? [String: [String: Any]] else {
//            return self.defaultDataset()
//        }
//        return dict
//    }
//    private func defaultDataset() -> [String: [String: Any]] { return [:] }
//    private func saveDataset(_ dataset: [String: [String: Any]]) {
//        var result = [String: [String: Any]]()
//        for (namespace, data) in dataset {
//            var subset = [String: Any]()
//            for (key, value) in data {
//                subset[key] = value
//            }
//            result[namespace] = subset
//        }
//        
//        (result as NSDictionary).write(toFile: self.fileName, atomically: true)
//    }
//}
