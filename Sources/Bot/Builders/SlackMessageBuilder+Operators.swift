//
//  SlackMessageBuilder+Operators.swift
//  Chameleon
//
//  Created by Ian Keen on 6/06/2016.
//
//

import Models

/**
 These are a set of optional operators to make constructing a `SlackMessage` made of lots of components a little more fluent
 Everything these operators do can be done with the `SlackMessage` object directly
 */


//MARK: - SlackMessage Operators
public func +(builder: SlackMessage, value: String) -> SlackMessage {
    return builder.text(value)
}
public func +(builder: SlackMessage, value: User) -> SlackMessage {
    return builder.user(value)
}
public func +(builder: SlackMessage, value: Channel) -> SlackMessage {
    return builder.channel(value)
}
public func +(builder: SlackMessage, value: URL) -> SlackMessage {
    return builder.url(value)
}
public func +(builder: SlackMessage, value: SlackMessage.Command) -> SlackMessage {
    return builder.command(value)
}
public func +(builder: SlackMessage, value: SlackEmoji) -> SlackMessage {
    return builder.emoji(value)
}
