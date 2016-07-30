//
//  ReactionBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 20/07/2016.
//
//

import Models

private enum ReactionEvent: String, RTMAPIEventBuilderEventType {
    case reaction_added, reaction_removed
    
    static var all: [ReactionEvent] { return [.reaction_added, .reaction_removed] }
}

/// Handler for the reaction events
struct ReactionBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ReactionEvent.all.map({ $0.rawValue }) }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard let event = ReactionEvent.eventType(fromJson: json)
            else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        let reaction: String = try builder.property("reaction")
        let user: User = try builder.lookup("user")
        let itemCreator: User? = try builder.optionalLookup("item_user")
        let target: Target? = try builder.optionalTarget("item.channel")
        
        switch event {
        case .reaction_added:
            return .reaction_added(
                reaction: reaction,
                user: user,
                itemCreator: itemCreator,
                target: target
            )

        case .reaction_removed:
            return .reaction_removed(
                reaction: reaction,
                user: user,
                itemCreator: itemCreator,
                target: target
            )
        }
    }
}
