//
//  Group+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension Group: SlackModelType {
    public static func make(with builder: SlackModelBuilder) throws -> Group {
        return try tryMake(Group(
            id:                     try builder.property("id"),
            name:                   try builder.property("name"),
            created:                try builder.property("created"),
            creator:                try builder.slackModel("creator"),
            is_group:               builder.property("is_group"),
            is_archived:            builder.property("is_archived"),
            is_mpim:                builder.property("is_mpim"),
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
