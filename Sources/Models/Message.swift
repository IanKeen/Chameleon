//
//  Message.swift
//  Slack
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Common

public struct Message {
    public let subtype: SubType?
    public let timestamp: String
    
    public let text: String?
    
    public let channel: FailableBox<Target>?
    public let user: User?
    public let inviter: User?
    
    public let bot: User?
    public let username: String?
    public let icons: [String: Any]?
    
    public let hidden: Bool
    public let deleted_ts: String?
    public let topic: String?
    public let purpose: String?
    public let old_name: String?
    public let name: String?
    
    public let members: [User]?
    public let file: [String: Any]? //File?
    public let upload: Bool
    public let comment: AnyObject?
    
    public let item_type: ItemType?
    public let item: [String: Any]?
    
    public let is_starred: Bool
    public let pinned_to: FailableBox<[Target]>?
    
    public let reactions: [Reaction]?
    
    public let edited: Edit?
    
    public let attachments: [Attachment]?
}

extension Message: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Message {
        return try tryMake(Message(
            subtype:        builder.optionalProperty("subtype"),
            timestamp:      try builder.property("ts"),
            text:           builder.optionalProperty("text"),
            channel:        FailableBox(try builder.optionalSlackModel("channel")),
            user:           try builder.optionalSlackModel("user"),
            inviter:        try builder.optionalSlackModel("inviter"),
            bot:            try builder.optionalSlackModel("bot_id"),
            username:       builder.optionalProperty("username"),
            icons:          builder.optionalProperty("icons"),
            hidden:         builder.property("hidden"),
            deleted_ts:     builder.optionalProperty("deleted_ts"),
            topic:          builder.optionalProperty("topic"),
            purpose:        builder.optionalProperty("purpose"),
            old_name:       builder.optionalProperty("old_name"),
            name:           builder.optionalProperty("name"),
            members:        try builder.optionalSlackModels("members"),
            file:           builder.optionalProperty("file"),
            upload:         builder.property("upload"),
            comment:        builder.optionalProperty("comment"),
            item_type:      builder.optionalProperty("item_type"),
            item:           builder.optionalProperty("item"),
            is_starred:     builder.property("is_starred"),
            pinned_to:      FailableBox(try builder.optionalSlackModels("pinned_to")),
            reactions:      try builder.optionalCollection("reactions"),
            edited:         try builder.optionalProperty("edited"),
            attachments:    try builder.optionalCollection("attachments")
            )
        )
    }
}
