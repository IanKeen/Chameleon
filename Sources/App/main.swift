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

let config = try Config(from: DefaultConfigInput)

//let bot = SlackBot(
//    config: config,
//    services: [HelloBot(), ButtonBot()]
//)

//let oauth = OAuthAuthentication(
//    http: HTTPProvider(),
//    server: HTTPServerProvider(),
//    clientId: "4962332711.62338921731",
//    clientSecret: "ffa5dcdc68698c3dcaa70b0677d55478"
//)
//oauth.authenticate(
//    success: { token in
//        print("TOKEN: \(token)")
//    },
//    failure: { error in
//        print("ERROR: \(error)")
//    }
//)

//bot.start()
