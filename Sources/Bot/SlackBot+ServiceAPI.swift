//
//  SlackBot+ServiceAPI.swift
//  Chameleon
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import WebAPI
import RTMAPI
import Services

/// An empty abstraction used to provide a 'base' for each type of supported service
public protocol SlackService { }

/// An abstraction that represents the 'connection' event
public protocol SlackConnectionService: SlackService {
    /**
     Called when the bot has finished conenction to Slack and all the data is ready
     
     - parameter slackBot: The `SlackBot` instance
     - parameter botUser:  The `BotUser` representing the `SlackBot`
     - parameter team:     The `Team` conencted to
     - parameter users:    The teams `User`s
     - parameter channels: The `Channel`s visible to the bot
     - parameter groups:   The `Group`s the bot is in
     - parameter ims:      The `IM`s with the bot
     */
    func connected(
        slackBot: SlackBot,
        botUser: BotUser,
        team: Team,
        users: [User],
        channels: [Channel],
        groups: [Group],
        ims: [IM]
    )
}

/// An abstraction that represents the 'disconnection' event
public protocol SlackDisconnectionService: SlackService {
    /**
     Called when the bot disconnects
     
     - parameter slackBot: The `SlackBot` instance
     - parameter error:    The `Error` _if_ the disconnection was a result of an error
     */
    func disconnected(slackBot: SlackBot, error: Error?)
}

/// An abstraction that represents the 'error' event
public protocol SlackErrorService: SlackService {
    /**
     Called when the bot encounters an error
     
     - parameter slackBot: The `SlackBot` instance
     - parameter error:    The `Error` describing the details
     */
    func error(slackBot: SlackBot, error: Error)
}

/// An abstraction that represents any `RTMAPI` event
public protocol SlackRTMEventService: SlackService {
    /**
     Called for every supported `RTMAPI` event
     
     - parameter slackBot: The `SlackBot` instance
     - parameter event:    The `RTMAPIEvent` with the event details
     - parameter webApi:   The current `WebAPI` that can be used to interact with Slack
     */
    func event(slackBot: SlackBot, event: RTMAPIEvent, webApi: WebAPI)
}

/// An abstraction that represents specialised access to the `RTMAPI` event `.message`
public protocol SlackMessageService: SlackService {
    /**
     Called when the `RTMAPI` emits the `.message` event
     
     - parameter slackBot: The `SlackBot` instance
     - parameter message:  The `MessageAdaptor` object of the received `Message`
     - parameter previous: If the message was an edit this will contain the previous `MessageAdaptor`, otherwise nil
     */
    func message(slackBot: SlackBot, message: MessageAdaptor, previous: MessageAdaptor?)
}
