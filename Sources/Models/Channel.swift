//
//  Channel.swift
// Chameleon
//
//  Created by Ian Keen on 25/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public struct Channel {
    public let id: String
    public let name: String
    
    public let created: Double
    public let creator: User
    
    public let is_channel: Bool
    public let is_general: Bool
    public let is_archived: Bool
    public let is_member: Bool
    
    public let members: [User]?
    
    public let topic: Topic?
    public let purpose: Purpose?
    
    public let last_read: Double?
    public let latest: Message?
    
    public let unread_count: Int?
    public let unread_count_display: Int?
}

extension Channel: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Channel {
        return try tryMake(Channel(
            id:                     try builder.property("id"),
            name:                   try builder.property("name"),
            created:                try builder.property("created"),
            creator:                try builder.slackModel("creator"),
            is_channel:             builder.property("is_channel"),
            is_general:             builder.property("is_general"),
            is_archived:            builder.property("is_archived"),
            is_member:              builder.property("is_member"),
            members:                try builder.optionalSlackModels("members"),
            topic:                  try builder.optionalProperty("topic"),
            purpose:                try builder.optionalProperty("purpose"),
            last_read:              builder.optionalProperty("last_read"),
            latest:                 try builder.optionalProperty("latest"),
            unread_count:           builder.optionalProperty("unread_count"),
            unread_count_display:   builder.optionalProperty("unread_count_display")
            )
        )

    }
}
