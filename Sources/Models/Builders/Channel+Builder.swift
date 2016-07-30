//
//  Channel+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension Channel: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Channel {
        return try tryMake(Channel(
            id:                     try builder.property("id"),
            name:                   try builder.property("name"),
            created:                try builder.property("created"),
            creator:                try builder.lookup("creator"),
            is_channel:             builder.default("is_channel"),
            is_general:             builder.default("is_general"),
            is_archived:            builder.default("is_archived"),
            is_member:              builder.default("is_member"),
            members:                try builder.optionalLookup("members"),
            topic:                  try builder.optionalModel("topic"),
            purpose:                try builder.optionalModel("purpose"),
            last_read:              builder.optionalProperty("last_read"),
            latest:                 try? builder.model("latest"),
            unread_count:           builder.optionalProperty("unread_count"),
            unread_count_display:   builder.optionalProperty("unread_count_display")
            )
        )
        
    }
}
