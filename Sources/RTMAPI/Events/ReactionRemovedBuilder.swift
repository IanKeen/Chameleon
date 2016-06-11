//
//  ReactionRemovedBuilder.swift
//  Slack
//
//  Created by Ian Keen on 22/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal struct ReactionRemovedBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "reaction_removed" }
    
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(json: json) else { throw RTMAPIEventBuilderError.InvalidBuilder }
        
        let builder = builderFactory(json: json)
        
        return .reaction_removed(
            reaction: try builder.property("reaction"),
            user: try builder.slackModel("user"),
            itemCreator: try? builder.slackModel("item_user"),
            target: try? builder.slackModel("item.channel")
        )
    }
}
