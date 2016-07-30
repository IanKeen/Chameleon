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
        return try tryMake(Message.Attachment(
            fallback:           try builder.property("fallback"),
            color:              try builder.optionalEnum("color"),
            pretext:            builder.optionalProperty("pretext"),
            author_name:        builder.optionalProperty("author_name"),
            author_link:        builder.optionalProperty("author_link"),
            author_icon:        builder.optionalProperty("author_icon"),
            title:              builder.optionalProperty("title"),
            title_link:         builder.optionalProperty("title_link"),
            text:               try builder.property("text"),
            fields:             try builder.optionalModels("fields", makeFunction: chooseField),
            actions:            try builder.optionalModels("actions", makeFunction: chooseField),
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
        return try tryMake(Message.Attachment.Field(
            title: try builder.property("title"),
            value: try builder.property("value"),
            short: builder.property("short")
            )
        )
    }
}

extension Message.Attachment.Button: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Message.Attachment.Button {
        return try tryMake(Message.Attachment.Button(
            name: try builder.property("name"),
            text: try builder.property("text"),
            style: try builder.optionalEnum("style"),
            value: try builder.property("value"),
            confirm: try builder.optionalModel("confirm")
            )
        )
    }
}
extension Message.Attachment.Button.Confirmation: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Message.Attachment.Button.Confirmation {
        return try tryMake(Message.Attachment.Button.Confirmation(
            title: builder.optionalProperty("title"),
            text: try builder.property("text"),
            ok_text: builder.optionalProperty("ok_text"),
            dismiss_text: builder.optionalProperty("dismiss_text")
            )
        )
    }
}

private func chooseField(input: [String: Any]) -> MakeFunction {
    return (input.keyPathExists("type")
        ? Message.Attachment.Button.makeModel
        : Message.Attachment.Field.makeModel
    )
}
