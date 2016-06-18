//
//  main.swift
//  Chameleon
//
//  Created by Ian Keen on 28/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Common
import Services
import WebAPI
import RTMAPI
import Bot
import Environment

let config = try SlackBotConfig.makeConfig(from: Environment())

let bot = SlackBot(
    config: config,
    storage: try RedisStorage(url: config.storageUrl!),
    apis:   [
                HelloBot(),
                KarmaBot(options: KarmaBot.Options(
                    targets: ["*"],
                    addText: "++",
                    addReaction: "+1",
                    removeText: "--",
                    removeReaction: "-1",
                    textDistanceThreshold: 4
                    )
        )
    ]
)

bot.start()
