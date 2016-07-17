//
//  GroupJoinedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

import Models
import Jay

/// Handler for the `group_joined` event
struct GroupJoinedBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "group_joined" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .group_joined(group: try builder.property("channel"))
    }
}
