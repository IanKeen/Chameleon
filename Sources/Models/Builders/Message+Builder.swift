//
//  Message+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

import Common

extension Message: SlackModelType {
    public static func make(with builder: SlackModelBuilder) throws -> Message {
        return try tryMake(Message(
            subtype:            builder.optionalProperty("subtype"),
            timestamp:          try builder.property("ts"),
            text:               builder.optionalProperty("text"),
            channel:            FailableBox(try builder.optionalSlackModel("channel")),
            user:               try builder.optionalSlackModel("user"),
            inviter:            try builder.optionalSlackModel("inviter"),
            bot:                try builder.optionalSlackModel("bot_id"),
            username:           builder.optionalProperty("username"),
            icons:              builder.optionalProperty("icons"),
            hidden:             builder.property("hidden"),
            deleted_ts:         builder.optionalProperty("deleted_ts"),
            topic:              builder.optionalProperty("topic"),
            purpose:            builder.optionalProperty("purpose"),
            old_name:           builder.optionalProperty("old_name"),
            name:               builder.optionalProperty("name"),
            members:            try builder.optionalSlackModels("members"),
            file:               builder.optionalProperty("file"),
            upload:             builder.property("upload"),
            comment:            builder.optionalProperty("comment"),
            item_type:          builder.optionalProperty("item_type"),
            item:               builder.optionalProperty("item"),
            is_starred:         builder.property("is_starred"),
            pinned_to:          FailableBox(try builder.optionalSlackModels("pinned_to")),
            reactions:          try builder.optionalCollection("reactions"),
            edited:             try builder.optionalProperty("edited"),
            attachments:        try builder.optionalCollection("attachments"),
            response_type:      try builder.optionalProperty("response_type"),
            replace_original:   builder.optionalProperty("replace_original"),
            delete_original:    builder.optionalProperty("delete_original")
            )
        )
    }
}
