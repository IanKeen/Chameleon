//
//  PresenceChangeBuilder.swift
//  Slack
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal struct PresenceChangeBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "presence_change" }
    
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(json: json) else { throw RTMAPIEventBuilderError.InvalidBuilder }
        
        let builder = builderFactory(json: json)
        
        return .presence_change(
            user: try builder.slackModel("user")
        )
    }
}
