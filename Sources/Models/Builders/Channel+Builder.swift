//
//  Channel+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension Channel: SlackModelType {
    public static func make(with builder: SlackModelBuilder) throws -> Channel {
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
            latest:                 try? builder.property("latest"),
            unread_count:           builder.optionalProperty("unread_count"),
            unread_count_display:   builder.optionalProperty("unread_count_display")
            )
        )
        
    }
}
