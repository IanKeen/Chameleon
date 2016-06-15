//
//  SlackBot+API.swift
// Chameleon
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import WebAPI
import RTMAPI

public protocol SlackAPI {
    func connected(
        slackBot: SlackBot,
        botUser: BotUser,
        team: Team,
        users: [User],
        channels: [Channel],
        groups: [Group],
        ims: [IM]
    )
    func disconnected(slackBot: SlackBot, error: ErrorProtocol?)
    func event(slackBot: SlackBot, event: RTMAPIEvent, webApi: WebAPI)
    func error(slackBot: SlackBot, error: ErrorProtocol)
}

public protocol SlackBotAPI: SlackAPI {
    func message(slackBot: SlackBot, message: MessageAdaptor, previous: MessageAdaptor?)
}
