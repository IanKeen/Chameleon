//
//  Message+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

import Common

extension Message: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Message {
        return try tryMake(builder, Message(
            subtype:            builder.optionalEnum("subtype"),
            timestamp:          try builder.property("ts"),
            text:               builder.optionalProperty("text"),
            channel:            FailableBox(try builder.optionalTarget("channel")),
            user:               try builder.optionalLookup("user"),
            inviter:            try builder.optionalLookup("inviter"),
            bot:                try builder.optionalLookup("bot_id"),
            username:           builder.optionalProperty("username"),
            icons:              builder.optionalProperty("icons"),
            hidden:             builder.default("hidden"),
            deleted_ts:         builder.optionalProperty("deleted_ts"),
            topic:              builder.optionalProperty("topic"),
            purpose:            builder.optionalProperty("purpose"),
            old_name:           builder.optionalProperty("old_name"),
            name:               builder.optionalProperty("name"),
            members:            try builder.optionalLookup("members"),
            file:               builder.optionalModel("file"),
            upload:             builder.default("upload"),
            comment:            builder.optionalProperty("comment"),
            item_type:          builder.optionalProperty("item_type"),
            item:               builder.optionalProperty("item"),
            is_starred:         builder.default("is_starred"),
            pinned_to:          FailableBox(try builder.optionalTargets("pinned_to")),
            reactions:          try builder.optionalModels("reactions"),
            edited:             try builder.optionalModel("edited"),
            attachments:        try builder.optionalModels("attachments"),
            response_type:      try builder.optionalEnum("response_type"),
            replace_original:   builder.optionalProperty("replace_original"),
            delete_original:    builder.optionalProperty("delete_original")
            )
        )
    }
}
