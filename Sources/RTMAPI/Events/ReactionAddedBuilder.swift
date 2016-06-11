//
//  ReactionAddedBuilder.swift
//  Slack
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal struct ReactionAddedBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "reaction_added" }
    
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(json: json) else { throw RTMAPIEventBuilderError.InvalidBuilder }
        
        let builder = builderFactory(json: json)
        
        return .reaction_added(
            reaction: try builder.property("reaction"),
            user: try builder.slackModel("user"),
            itemCreator: try? builder.slackModel("item_user"),
            target: try? builder.slackModel("item.channel")
        )
    }
}
