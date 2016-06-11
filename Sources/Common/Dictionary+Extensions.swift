//
//  Dictionary+Extensions.swift
//  Slack
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
    public mutating func append(contentsOf other: Dictionary<Key, Value>) {
        for (key, value) in other {
            self.updateValue(value, forKey: key)
        }
    }
}
