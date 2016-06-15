//
//  Message+Attachment.swift
// Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

extension Message {
    public struct Attachment {
        public let fallback: String
        public let color: String?
        public let pretext: String?
        
        public let author_name: String?
        public let author_link: String?
        public let author_icon: String?
        
        public let title: String?
        public let title_link: String?
        
        public let text: String
        
        public let fields: [Field]?
        
        public let from_url: String?
        public let image_url: String?
        public let thumb_url: String?
    }
}

extension Message.Attachment {
    public struct Field {
        public let title: String
        public let value: String
        public let short: Bool
    }
}

extension Message.Attachment: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Message.Attachment {
        return try tryMake(Message.Attachment(
            fallback:       try builder.property("fallback"),
            color:          builder.optionalProperty("color"),
            pretext:        builder.optionalProperty("pretext"),
            author_name:    builder.optionalProperty("author_name"),
            author_link:    builder.optionalProperty("author_link"),
            author_icon:    builder.optionalProperty("author_icon"),
            title:          builder.optionalProperty("title"),
            title_link:     builder.optionalProperty("title_link"),
            text:           try builder.property("text"),
            fields:         try builder.optionalCollection("fields"),
            from_url:       builder.optionalProperty("from_url"),
            image_url:      builder.optionalProperty("image_url"),
            thumb_url:      builder.optionalProperty("thumb_url")
            )
        )
    }
}

extension Message.Attachment.Field: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Message.Attachment.Field {
        return try tryMake(Message.Attachment.Field(
            title: try builder.property("title"),
            value: try builder.property("value"),
            short: builder.property("short")
            )
        )
    }
}