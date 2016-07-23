//
//  MessageAdaptor.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models

/// A wrapper around a `Message` model to provide additional functionality
public struct MessageAdaptor {
    //MARK: - Private
    private let slackModels: SlackBot.SlackModelClosure
    
    //MARK: - Public Raw Properties
    /// The underlying `Message` this `MessageAdaptor` uses
    public let message: Message
    
    //MARK: - Public Derived Properties
    /// `String` representing the text of the `Message`
    public var text: String { return self.message.text ?? "" }
    
    /// The `User` representing the sender of this `Message`
    public var sender: User? {
        return
            self.message.user ??
            self.message.edited?.user ??
            self.message.inviter ??
            self.message.bot
    }
    
    /// The `Target` for this `Message`
    public var target: Target? {
        return self.message.channel?.value
    }
    
    /// A sequence of mentioned `User`s in the `Message`
    public var mentioned_users: [User] {
        let users = slackModels().users + slackModels().users.botUsers()
        
        return self.mentionedLinks(prefix: "@")
            .flatMap { link in
                users.filter { $0.id == link.link }
            }
    }
    
    /// A sequence of mentioned `Channel`s in the `Message`
    public var mentioned_channels: [Channel] {
        let channels = slackModels().channels
        
        return self.mentionedLinks(prefix: "#")
            .flatMap { link in
                channels.filter { $0.id == link.link }
        }
    }
    
    /// A sequence of mentioned `Link`s in the `Message` that are not `Channel`s or `User`s
    public var mentioned_links: [Link] {
        return self.mentionedLinks() {
            !$0.link.hasPrefix("@") && !$0.link.hasPrefix("#")
        }
    }
    
    //MARK: - Lifecycle
    init(message: Message, slackModels: SlackBot.SlackModelClosure) {
        self.message = message
        self.slackModels = slackModels
    }
}

//MARK: - Link Extraction
private extension MessageAdaptor {
    private func mentionedLinks(prefix: String = "", filter: ((Link) -> Bool) = { _ in true }) -> [Link] {
        guard self.text.characters.contains("<") && self.text.characters.contains(">") else { return [] }
        
        //NOTE: so far I've just been avoid RegEx for the sake of it...
        //      however if I turn to the dark side the expression used should be <(.*?)>
        //
        //TODO
        //UPDATE: The more I look at the code below the more I dislike it :P - pony up and change to regex...
        //
        //From Slack: https://api.slack.com/docs/formatting
        //1. Detect all sequences matching <(.*?)>
        //2. Within those sequences, format content starting with #C as a channel link
        //3. Within those sequences, format content starting with @U as a user link
        //4. Within those sequences, format content starting with ! according to the rules for the special command.
        //5. For remaining sequences, format as a link
        //
        //Once the format has been determined, check for a pipe - if present, use the text following the pipe as the link label
        //
        return self.text
            .components(separatedBy: ">")
            .filter { $0.characters.contains("<") }
            .flatMap { $0.components(separatedBy: "<\(prefix)").last }
            .filter { !$0.isEmpty }
            .flatMap { Link(link: $0) }
            .filter { filter($0) }
    }
}

//MARK: - Message.Link
public extension MessageAdaptor {
    /// Represents a link extracted from a `Message`
    public struct Link {
        public let link: String
        public let displayText: String
        
        init?(link: String) {
            let components = link.components(separatedBy: "|")
            
            guard
                let first = components.first
                else { return nil }
            
            self.link = first
            self.displayText = components.last ?? first
        }
    }
}

//MARK: - Convenience: Message to MessageAdaptor
extension Message {
    func toAdaptor(slackModels: SlackBot.SlackModelClosure) -> MessageAdaptor {
        return MessageAdaptor(message: self, slackModels: slackModels)
    }
}
