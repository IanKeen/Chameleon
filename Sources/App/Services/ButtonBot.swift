//
//  ButtonBot.swift
//  Chameleon
//
//  Created by Ian Keen on 20/07/2016.
//
//

import Bot
import RTMAPI
import WebAPI
import Models
import Vapor

extension Message.Attachment {
    public static func makeButtonAttachment(title: String, text: String, color: SlackColor? = nil, buttons: [Button]) -> (attachment: Message.Attachment, callback_id: String) {
        let callback_id = String(Int.random(1, max: 999999))
        
        let attachment = Message.Attachment(
            fallback: title,
            color: color,
            pretext: nil,
            author_name: nil,
            author_link: nil,
            author_icon: nil,
            title: title,
            title_link: nil,
            text: text,
            fields: buttons.map { $0 as MessageAttachmentField },
            from_url: nil,
            image_url: nil,
            thumb_url: nil,
            callback_id: callback_id
        )
        
        return (attachment, callback_id)
    }
}

final class ButtonBot: SlackMessageService {
    func message(slackBot: SlackBot, message: MessageAdaptor, previous: MessageAdaptor?) {
        
        guard
            let channel = message.target?.channel?.name,
            let sender = message.sender?.name
            where channel == "bot-laboratory" &&
                sender.hasPrefix("ian") &&
                message.text == "button"
            else { return }
        
        let (attachment, callback_id) = Message.Attachment
            .makeButtonAttachment(
                title: "this is the title",
                text: "this is the text",
                color: .danger,
                buttons: [
                    Message.Attachment.Button(
                        name: "Button 1",
                        text: "Text 1",
                        style: .default,
                        value: "value1",
                        confirm: nil
                    ),
                    Message.Attachment.Button(
                        name: "Button 2",
                        text: "Text 2",
                        style: .primary,
                        value: "value2",
                        confirm: nil
                    ),
                    Message.Attachment.Button(
                        name: "Button 3",
                        text: "Text 3",
                        style: .danger,
                        value: "value3",
                        confirm: Message.Attachment.Button.Confirmation(
                            title: "Title",
                            text: "Text",
                            ok_text: "ok",
                            dismiss_text: "dismiss"
                        )
                    )
                ]
        )
        
//        print(attachment)
//        print(callback_id)
        print(attachment.makeJSON().jsonValueDescription)
    }
}
