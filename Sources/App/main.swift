//
//  main.swift
//  Slack
//
//  Created by Ian Keen on 28/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Common
import Services
import WebAPI
import RTMAPI
import Bot

let config = try SlackBotConfig()

let bot = SlackBot(
    config: config,
    apis:   [HelloBot()]
)

bot.start()
