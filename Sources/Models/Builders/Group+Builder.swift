//
//  Group+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension Group: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Group {
        return try tryMake(Group(
            id:                     try builder.property("id"),
            name:                   try builder.property("name"),
            created:                try builder.property("created"),
            creator:                try builder.lookup("creator"),
            is_group:               builder.default("is_group"),
            is_archived:            builder.default("is_archived"),
            is_mpim:                builder.default("is_mpim"),
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
