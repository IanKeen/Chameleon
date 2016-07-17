//
//  GroupArchiveBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

import Models
import Jay

/// Handler for the `group_archive` event
struct GroupArchiveBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "group_archive" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .group_archive(group: try builder.slackModel("channel"))
    }
}
