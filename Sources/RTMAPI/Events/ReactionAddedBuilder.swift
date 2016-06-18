//
//  ReactionAddedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

/// Handler for the `reaction_added` event
struct ReactionAddedBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "reaction_added" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .reaction_added(
            reaction: try builder.property("reaction"),
            user: try builder.slackModel("user"),
            itemCreator: try? builder.slackModel("item_user"),
            target: try? builder.slackModel("item.channel")
        )
    }
}
