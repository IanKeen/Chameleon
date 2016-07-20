//
//  PresenceChangeBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Vapor

/// Handler for the `presence_change` event
struct PresenceChangeBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["presence_change"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .presence_change(
            user: try builder.slackModel("user")
        )
    }
}
