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
import Engine
import Strand

extension Message.Attachment {
    public static func makeButtonAttachments(text: String, color: SlackColor? = nil, buttons: [Button]) -> (attachment: Message.Attachment, callback_id: String) {
        let callback_id = "\(Int.random(min: 1, max: 999999))"
        
        let attachment = Message.Attachment(
            fallback: text,
            color: color,
            pretext: nil,
            author_name: nil,
            author_link: nil,
            author_icon: nil,
            title: nil,
            title_link: nil,
            text: text,
            fields: nil,
            actions: buttons.map { $0 as MessageAttachmentField },
            from_url: nil,
            image_url: nil,
            thumb_url: nil,
            callback_id: callback_id,
            attachment_type: "default"
        )
        
        return (attachment, callback_id)
    }
}

final class ButtonBot: SlackMessageService {
    private let server = Droplet()
    private var thread: Strand!
    private var slackBot: SlackBot?
    private var target: Target?
    
    init() {
        self.thread = try! Strand { [unowned self] in
            self.server.post { request in
                print(request)
                if let bot = self.slackBot, target = self.target {
                    bot.chat(with: target, text: "post")
                }
                return ""
            }
            self.server.post("/button") { request in
                print(request)
                if let bot = self.slackBot, target = self.target {
                    bot.chat(with: target, text: "post/button")
                }
                return try Response(status: .ok, json: .null)
            }
            self.server.get { request -> ResponseRepresentable in
                print(request)
                if let bot = self.slackBot, target = self.target {
                    bot.chat(with: target, text: "get")
                }
                return ""
            }
            self.server.serve()
        }
    }
    
    func message(slackBot: SlackBot, message: MessageAdaptor, previous: MessageAdaptor?) {
        guard
            let target = message.target,
            let channel = target.channel?.name,
            let sender = message.sender?.name
            where channel == "bot-laboratory" &&
                sender.hasPrefix("ian") &&
                message.text == "button"
            else { return }
        
        self.slackBot = slackBot
        self.target = target
        
        let (attachment, callback_id) = Message.Attachment
            .makeButtonAttachments(
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
        
        slackBot.chat(with: target, text: "hello", attachments: [attachment])
        
    }
}
