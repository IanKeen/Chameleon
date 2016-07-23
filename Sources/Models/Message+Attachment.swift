//
//  Message+Attachment.swift
//  Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

extension Message {
    public struct Attachment {
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
        public let actions: [MessageAttachmentField]?
        
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
            actions: [MessageAttachmentField]?,
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
}

extension Message.Attachment {
    public struct Field {
        public let title: String
        public let value: String
        public let short: Bool
    }
}

extension Message.Attachment {
    public struct Button {
        public let name: String
        public let text: String
        public let style: Style?
        public let type: String = "button"
        public let value: String
        public let confirm: Confirmation?
        
        public init(name: String, text: String, style: Style?, value: String, confirm: Confirmation?) {
            self.name = name
            self.text = text
            self.style = style
            self.value = value
            self.confirm = confirm
        }
    }
}
extension Message.Attachment.Button {
    public struct Confirmation {
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
}
extension Message.Attachment.Button {
    public enum Style: String, JSONRepresentable {
        case `default`
        case primary
        case danger
    }
}
