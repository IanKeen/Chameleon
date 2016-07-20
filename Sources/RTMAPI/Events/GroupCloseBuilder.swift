//
//  GroupCloseBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

import Models
import Vapor

/// Handler for the `group_close` event
struct GroupCloseBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "group_close" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .group_close(
            user: try builder.slackModel("user"),
            group: try builder.slackModel("channel")
        )
    }
}
