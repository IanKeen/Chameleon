//
//  GroupMarkedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

import Models
import Jay

/// Handler for the `group_marked` event
struct GroupMarkedBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "group_marked" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .group_marked(
            group: try builder.slackModel("channel"),
            timestamp: try builder.property("ts")
        )
    }
}
