//
//  SlackBot+Interaction.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import WebAPI

public extension SlackBot {
    var me: User {
        guard
            let botUser = self.botUser,
            let me = self.users.filter({ $0.id == botUser.id || $0.bot_id == botUser.id }).first
            else { fatalError("This shouldn't happen") }
        
        return me
    }
    public func isMe(user: User) -> Bool {
        let users = self.users + self.users.botUsers()
        return users.botUsers().contains { $0 == user }
    }
    
    public func chat(target: Target, text: String, options: [ChatPostMessage.Option] = [], attachments: [Message.Attachment] = []) {
        let chat = ChatPostMessage(
            target: target,
            text: text,
            options: [
                .linkNames(true)
            ] + options,
            attachments: attachments
        )
        
        do { try self.webAPI.execute(method: chat) }
        catch let error { self.notify(error: error) }
    }
    public func chat(message: SlackMessage) {
        do { try self.webAPI.execute(method: message.apiMethod()) }
        catch let error { self.notify(error: error) }
    }
}
