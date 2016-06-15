//
//  User.swift
// Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public struct User {
    public internal(set) var id: String
    public let bot_id: String?
    public let team_id: String
    public let name: String
    public let real_name: String?
    public let status: String?
    public let presence: Presence?
    public let title: String?
    
    public let image_24: String?
    public let image_32: String?
    public let image_48: String?
    public let image_72: String?
    public let image_192: String?
    public let image_512: String?
    
    public let is_bot: Bool
    public let is_admin: Bool
    public let is_owner: Bool
    public let is_primary_owner: Bool
    public let is_restricted: Bool
    public let is_ultra_restricted: Bool
}

public extension User {
    public enum Presence: String {
        case Active = "active"
        case Away = "away"
    }
}

