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

extension User: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> User {
        return try tryMake(User(
            id:                     try builder.property("id"),
            bot_id:                 builder.optionalProperty("profile.bot_id"),
            team_id:                try builder.property("team_id"),
            name:                   try builder.property("name"),
            real_name:              builder.optionalProperty("real_name"),
            status:                 builder.optionalProperty("status"),
            presence:               builder.optionalProperty("presence"),
            title:                  builder.optionalProperty("profile.title"),
            image_24:               builder.optionalProperty("profile.image_24"),
            image_32:               builder.optionalProperty("profile.image_32"),
            image_48:               builder.optionalProperty("profile.image_48"),
            image_72:               builder.optionalProperty("profile.image_72"),
            image_192:              builder.optionalProperty("profile.image_192"),
            image_512:              builder.optionalProperty("profile.image_512"),
            is_bot:                 builder.property("is_bot"),
            is_admin:               builder.property("is_admin"),
            is_owner:               builder.property("is_owner"),
            is_primary_owner:       builder.property("is_primary_owner"),
            is_restricted:          builder.property("is_restricted"),
            is_ultra_restricted:    builder.property("is_ultra_restricted")
            )
        )
    }
}
