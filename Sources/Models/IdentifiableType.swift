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

    func asUser() -> User?
    func asBotUser() -> BotUser?
    func asTeam() -> Team?
    func asChannel() -> Channel?
    func asGroup() -> Group?
    func asIM() -> IM?
}

extension IdentifiableType {
    public func asUser() -> User? { return nil }
    public func asBotUser() -> BotUser? { return nil }
    public func asTeam() -> Team? { return nil }
    public func asChannel() -> Channel? { return nil }
    public func asGroup() -> Group? { return nil }
    public func asIM() -> IM? { return nil }
}

extension User: IdentifiableType {
    public func asUser() -> User? { return self }
}
extension BotUser: IdentifiableType {
    public func asBotUser() -> BotUser? { return self }
}
extension Team: IdentifiableType {
    public func asTeam() -> Team? { return self }
}
extension Channel: IdentifiableType {
    public func asChannel() -> Channel? { return self }
}
extension Group: IdentifiableType {
    public func asGroup() -> Group? { return self }
}
extension IM: IdentifiableType {
    public func asIM() -> IM? { return self }
}

public func ==<T: IdentifiableType>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}
