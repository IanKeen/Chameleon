//
//  PingPongBuilder.swift
//  Slack
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal struct PingPongBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "pong" }
    
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(json: json) else { throw RTMAPIEventBuilderError.InvalidBuilder }
        return .pong(response: json)
    }
}
