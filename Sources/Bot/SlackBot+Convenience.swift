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

public extension SlackBot {
    /**
     Provides a convenience `init` for a `SlackBot` instance prodiving the default `WebAPI` and `RTMAPI` instances.
     
     - parameter config:   The `SlackBotConfig` to use for this `SlackBot` instance
     - parameter storage:  The `Storage` to use, `MemoryStorage` will be used if nothing is provided
     - parameter services: The sequence of `SlackService`s to use
     
     - returns: A new `SlackBot` instance
     */
    public convenience init(config: SlackBotConfig, storage: Storage = MemoryStorage(), services: [SlackService]) {
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
            services: services
        )
    }
}
