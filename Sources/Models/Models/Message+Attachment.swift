public struct MessageAttachment {
    public let fallback: String
    public let color: SlackColor?
    public let pretext: String?
    
    public let author_name: String?
    public let author_link: String?
    public let author_icon: String?
    
    public let title: String?
    public let title_link: String?
    
    public let text: String
    
    public let fields: [MessageAttachmentField]?
    public let actions: [MessageAttachmentAction]?
    
    public let from_url: String?
    public let image_url: String?
    public let thumb_url: String?
    
    public let callback_id: String?
    public let attachment_type: String?
    
    //TODO: Remove this once memberwise `init`s follow the structs access :(
    public init(
        fallback: String,
        color: SlackColor?,
        pretext: String?,
        author_name: String?,
        author_link: String?,
        author_icon: String?,
        title: String?,
        title_link: String?,
        text: String,
        fields: [MessageAttachmentField]?,
        actions: [MessageAttachmentAction]?,
        from_url: String?,
        image_url: String?,
        thumb_url: String?,
        callback_id: String?,
        attachment_type: String?) {
        
        self.fallback = fallback
        self.color = color
        self.pretext = pretext
        self.author_name = author_name
        self.author_link = author_link
        self.author_icon = author_icon
        self.title = title
        self.title_link = title_link
        self.text = text
        self.fields = fields
        self.actions = actions
        self.from_url = from_url
        self.image_url = image_url
        self.thumb_url = thumb_url
        self.callback_id = callback_id
        self.attachment_type = attachment_type
    }
}

public struct MessageAttachmentField {
    public let title: String
    public let value: String
    public let short: Bool
}

public struct MessageAttachmentAction {
    public let name: String
    public let text: String
    public let style: MessageAttachmentActionStyle?
    public let type: String = "button"
    public let value: String
    public let confirm: MessageAttachmentActionConfirmation?
    
    public init(name: String, text: String, style: MessageAttachmentActionStyle?, value: String, confirm: MessageAttachmentActionConfirmation?) {
        self.name = name
        self.text = text
        self.style = style
        self.value = value
        self.confirm = confirm
    }
}

public struct MessageAttachmentActionConfirmation {
    public let title: String?
    public let text: String
    public let ok_text: String?
    public let dismiss_text: String?
    
    public init(title: String?, text: String, ok_text: String?, dismiss_text: String?) {
        self.title = title
        self.text = text
        self.ok_text = ok_text
        self.dismiss_text = dismiss_text
    }
}

public enum MessageAttachmentActionStyle: String, SlackModelValueType {
    case `default`
    case primary
    case danger
}
