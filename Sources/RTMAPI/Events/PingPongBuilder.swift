//
//  PingPongBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models

/// Handler for the `pong` event
struct PingPongBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["pong"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        return .pong(response: json)
    }
}
