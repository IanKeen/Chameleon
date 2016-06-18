//
//  Dictionary+Extensions.swift
//  Chameleon
//
//  Created by Ian Keen on 11/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation

public func +<Key, Value>(lhs: [Key: Value]?, rhs: [Key: Value]?) -> [Key: Value] {
    let lhs = lhs ?? [:]
    let rhs = rhs ?? [:]
    
    var result = lhs
    result.append(contentsOf: rhs)
    return result
}

public extension Dictionary {
    /**
     Adds the elements of another dictionary with the same `Key` and `Value` to the dictionary.
     
     NOTE: If the other dictionary has keys that already exist in this dictionary then will be replaced.
     
     - parameter other: The `Dictionary<Key, Value>` to append.
     */
    public mutating func append(contentsOf other: Dictionary<Key, Value>) {
        for (key, value) in other {
            self.updateValue(value, forKey: key)
        }
    }
}
