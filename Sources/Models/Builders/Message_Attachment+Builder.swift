import Common

extension MessageAttachment: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> MessageAttachment {
        return try tryMake(builder, MessageAttachment(
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

extension MessageAttachmentField: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> MessageAttachmentField {
        return try tryMake(builder, MessageAttachmentField(
            title: try builder.property("title"),
            value: try builder.property("value"),
            short: builder.property("short")
            )
        )
    }
}

extension MessageAttachmentAction: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> MessageAttachmentAction {
        return try tryMake(builder, MessageAttachmentAction(
            name: try builder.property("name"),
            text: try builder.property("text"),
            style: try builder.optionalEnum("style"),
            value: try builder.property("value"),
            confirm: try builder.optionalModel("confirm")
            )
        )
    }
}
extension MessageAttachmentActionConfirmation: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> MessageAttachmentActionConfirmation {
        return try tryMake(builder, MessageAttachmentActionConfirmation(
            title: builder.optionalProperty("title"),
            text: try builder.property("text"),
            ok_text: builder.optionalProperty("ok_text"),
            dismiss_text: builder.optionalProperty("dismiss_text")
            )
        )
    }
}
