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

#if os(Linux)
    import Environment
    let config = try SlackBotConfig.makeConfig(from: Environment())
#else
    import Foundation
    let config = try SlackBotConfig.makeConfig(from: NSProcessInfo.processInfo())
#endif

let bot = SlackBot(
    config: config,
    services: [
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
