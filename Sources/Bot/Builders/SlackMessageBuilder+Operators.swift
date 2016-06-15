//
//  SlackMessageBuilder+Operators.swift
// Chameleon
//
//  Created by Ian Keen on 6/06/2016.
//
//

import Models
import Foundation

func +(builder: SlackMessage, value: String) -> SlackMessage {
    return builder.text(value)
}
func +(builder: SlackMessage, value: User) -> SlackMessage {
    return builder.user(value)
}
func +(builder: SlackMessage, value: Channel) -> SlackMessage {
    return builder.channel(value)
}
func +(builder: SlackMessage, value: NSURL) -> SlackMessage {
    return builder.url(value)
}
func +(builder: SlackMessage, value: SlackMessage.Command) -> SlackMessage {
    return builder.command(value)
}
func +(builder: SlackMessage, value: SlackEmoji) -> SlackMessage {
    return builder.emoji(value)
}
