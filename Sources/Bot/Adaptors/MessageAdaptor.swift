//
//  MessageAdaptor.swift
// Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models

public struct MessageAdaptor {
    //MARK: - Private
    private let slackModels: SlackBot.SlackModelClosure
    
    //MARK: - Public Raw Properties
    public let message: Message
    
    //MARK: - Public Derived Properties
    public var text: String { return self.message.text ?? "" }
    public var sender: User? {
        return
            self.message.user ??
            self.message.edited?.user ??
            self.message.inviter ??
            self.message.bot
    }
    public var target: Target? {
        return self.message.channel?.value
    }
    public var mentioned_users: [User] {
        let users = slackModels().users + slackModels().users.botUsers()
        
        return self.mentionedLinks(prefix: "@")
            .flatMap { link in
                users.filter { $0.id == link.link }
            }
    }
    public var mentioned_channels: [Channel] {
        let channels = slackModels().channels
        
        return self.mentionedLinks(prefix: "#")
            .flatMap { link in
                channels.filter { $0.id == link.link }
        }
    }
    public var mentioned_links: [Link] {
        return self.mentionedLinks() {
            !$0.link.hasPrefix("@") && !$0.link.hasPrefix("#")
        }
    }
    private func mentionedLinks(prefix: String = "", filter: ((Link) -> Bool) = { _ in true }) -> [Link] {
        guard self.text.characters.contains("<") && self.text.characters.contains(">") else { return [] }
        
        //NOTE: so far I've just been avoid RegEx for the sake of it...
        //      however if I turn to the dark side the expression used should be <(.*?)>
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
    
    //MARK: - Lifecycle
    init(message: Message, slackModels: SlackBot.SlackModelClosure) {
        self.message = message
        self.slackModels = slackModels
    }
}

extension MessageAdaptor {
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

extension Message {
    func toAdaptor(slackModels: SlackBot.SlackModelClosure) -> MessageAdaptor {
        return MessageAdaptor(message: self, slackModels: slackModels)
    }
}
