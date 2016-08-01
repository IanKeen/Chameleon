//
//  Message_Attachment+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

import Common

extension Message.Attachment: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Message.Attachment {
        return try tryMake(builder, Message.Attachment(
            fallback:           try builder.property("fallback"),
            color:              try builder.optionalEnum("color"),
            pretext:            builder.optionalProperty("pretext"),
            author_name:        builder.optionalProperty("author_name"),
            author_link:        builder.optionalProperty("author_link"),
            author_icon:        builder.optionalProperty("author_icon"),
            title:              builder.optionalProperty("title"),
            title_link:         builder.optionalProperty("title_link"),
            text:               try builder.property("text"),
            fields:             try builder.optionalModels("fields"),
            actions:            try builder.optionalModels("actions"),
            from_url:           builder.optionalProperty("from_url"),
            image_url:          builder.optionalProperty("image_url"),
            thumb_url:          builder.optionalProperty("thumb_url"),
            callback_id:        builder.optionalProperty("callback_id"),
            attachment_type:    builder.optionalProperty("attachment_type")
            )
        )
    }
}

extension Message.Attachment.Field: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Message.Attachment.Field {
        return try tryMake(builder, Message.Attachment.Field(
            title: try builder.property("title"),
            value: try builder.property("value"),
            short: builder.property("short")
            )
        )
    }
}

extension Message.Attachment.Action: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Message.Attachment.Action {
        return try tryMake(builder, Message.Attachment.Action(
            name: try builder.property("name"),
            text: try builder.property("text"),
            style: try builder.optionalEnum("style"),
            value: try builder.property("value"),
            confirm: try builder.optionalModel("confirm")
            )
        )
    }
}
extension Message.Attachment.Action.Confirmation: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Message.Attachment.Action.Confirmation {
        return try tryMake(builder, Message.Attachment.Action.Confirmation(
            title: builder.optionalProperty("title"),
            text: try builder.property("text"),
            ok_text: builder.optionalProperty("ok_text"),
            dismiss_text: builder.optionalProperty("dismiss_text")
            )
        )
    }
}
