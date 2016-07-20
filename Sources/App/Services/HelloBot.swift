//
//  HelloBot.swift
//  Chameleon
//
//  Created by Ian Keen on 4/06/2016.
//
//

import Bot
import RTMAPI
import WebAPI
import Models

final class HelloBot: SlackMessageService {
    func message(slackBot: SlackBot, message: MessageAdaptor, previous: MessageAdaptor?) {
        let greetings = ["hello", "hi", "hey"]
        guard
            let target = message.target, sender = message.sender
            else { return }
        if (message.text.hasPrefix(options: greetings) && message.mentioned_users.contains(slackBot.me)) {
            slackBot.chat(with: target, text: "hey, <@\(sender.id)>")
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
