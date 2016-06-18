//
//  Message_Attachment+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

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