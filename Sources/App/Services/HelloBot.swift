//
//  HelloBot.swift
// Chameleon
//
//  Created by Ian Keen on 4/06/2016.
//
//

import Bot
import RTMAPI
import WebAPI
import Models

final class HelloBot: SlackBotAPI {
    func connected(slackBot: SlackBot, botUser: BotUser, team: Team, users: [User], channels: [Channel], groups: [Group], ims: [IM]) { }
    func disconnected(slackBot: SlackBot, error: ErrorProtocol?) { }
    func error(slackBot: SlackBot, error: ErrorProtocol) { }
    func event(slackBot: SlackBot, event: RTMAPIEvent, webApi: WebAPI) { }

    func message(slackBot: SlackBot, message: MessageAdaptor, previous: MessageAdaptor?) {
        let greetings = ["hello", "hi", "hey"]
        guard
            let target = message.target, sender = message.sender
            else { return }
        
        if (message.text.hasPrefix(options: greetings) && message.mentioned_users.contains(slackBot.me)) {
            slackBot.chat(target: target, text: "hey, <@\(sender.id)>")
        }
    }
}

extension String {
    func hasPrefix(options: [String]) -> Bool {
        for option in options where self.hasPrefix(option) {
            return true
        }
        return false
    }
}