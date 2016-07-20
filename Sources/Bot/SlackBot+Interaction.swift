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
    /// Provides access to the `SlackBot`s `User` model
    public var me: User {
        guard
            let botUser = self.botUser,
            let me = self.users.filter({ $0.id == botUser.id || $0.bot_id == botUser.id }).first
            else { fatalError("This shouldn't happen") }
        
        return me
    }
    
    /**
     Find out if the provided `User` is the `SlackBot`s `User` model
     
     - parameter user: The `User` to test
     - returns: `true` if the provided `User`s represents this bot, otherwise `false`
     */
    public func isMe(_ user: User) -> Bool {
        let users = self.users + self.users.botUsers()
        return users.botUsers().contains { $0 == user }
    }
    
    /// Provides access to the current Slack teams admins
    public var admins: [User] {
        return self.users.filter { $0.is_admin }
    }
    
    /**
     Find out if the provided `User` is an admin in the current Slack team
     
     - parameter user: The `User` to test
     - returns: `true` if the provided `User` is an admin, otherwise `false`
     */
    public func isAdmin(_ user: User) -> Bool {
        return self.admins.contains(user)
    }
    
    /**
     Convenience function to send a message to Slack
     
     - parameter target:      The `Target` representing who or what you are chatting with
     - parameter text:        The `String` with the text to send
     - parameter options:     Any `ChatPostMessage.Option`s specific to this message (optional)
     - parameter attachments: Any `Message.Attachment`s to include (optional)
     */
    public func chat(with target: Target, text: String, options: [ChatPostMessage.Option] = [], attachments: [Message.Attachment] = []) {
        let chat = ChatPostMessage(
            target: target,
            text: text,
            options: [
                .linkNames(true)
            ] + options,
            attachments: attachments
        )
        
        do { try self.webAPI.execute(chat) }
        catch let error { self.notify(error: error) }
    }
    
    /**
     Convenience function to send a `SlackMessage` to Slack
     
     - parameter message: The `SlackMessage` representing the message to send
     */
    public func chat(_ message: SlackMessage) {
        do { try self.webAPI.execute(message.apiMethod()) }
        catch let error { self.notify(error: error) }
    }
}
