//
//  SlackBot+Convenience.swift
//  Chameleon
//
//  Created by Ian Keen on 7/06/2016.
//
//

import Services
import WebAPI
import RTMAPI

extension SlackBot {
    public convenience init(config: SlackBotConfig, storage: Storage = MemoryStorage(), apis: [SlackAPI]) {
        let http = HTTPProvider()
        let websocket = WebSocketProvider()
        let storage = storage
        
        let webAPI = WebAPI(token: config.token, http: http)
        let rtmAPI = RTMAPI(websocket: websocket)
        
        self.init(
            config: config,
            storage: storage,
            webAPI: webAPI,
            rtmAPI: rtmAPI,
            apis: apis
        )
    }
}