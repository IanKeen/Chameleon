//
//  IdentifiableType.swift
// Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public protocol IdentifiableType: Equatable {
    var id: String { get }
}

extension User: IdentifiableType { }
extension BotUser: IdentifiableType { }
extension Team: IdentifiableType { }
extension IM: IdentifiableType { }

public func ==<T: IdentifiableType>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}
