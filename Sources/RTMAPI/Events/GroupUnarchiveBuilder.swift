//
//  GroupUnarchiveBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

import Models
import Vapor

/// Handler for the `group_unarchive` event
struct GroupUnarchiveBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["group_unarchive"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .group_unarchive(group: try builder.slackModel("channel"))
    }
}
