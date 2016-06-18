//
//  IdentifiableType.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

/// An abstraction for an object that can be identified by a unique `id` and can use that `id` to compare equality
public protocol IdentifiableType: Equatable {
    /// The unique id for this object
    var id: String { get }
}

extension User: IdentifiableType { }
extension BotUser: IdentifiableType { }
extension Team: IdentifiableType { }
extension IM: IdentifiableType { }

public func ==<T: IdentifiableType>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}
