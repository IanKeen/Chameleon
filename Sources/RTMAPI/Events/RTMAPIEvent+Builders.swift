//
//  RTMAPIEvent+Builders.swift
//  Slack
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal enum RTMAPIEventBuilderError: ErrorProtocol {
    case NoAvailableBuilder(type: String)
    case InvalidBuilder
}

internal protocol RTMAPIEventBuilder {
    static var eventType: String { get }
    static func canMake(json: JSON) -> Bool
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent
}

extension RTMAPIEventBuilder {
    static func canMake(json: JSON) -> Bool {
        guard let event = json["type"]?.string else { return false }
        return (event == self.eventType)
    }
}

internal extension RTMAPIEvent {
    static func builder(json: JSON) throws -> RTMAPIEventBuilder.Type {
        
        //Add builders here:
        //
        //The idea here is to break out the 'building' of all the slack events
        //in an attempt to manage their creation a little easier
        //rather than a single `init(json:)` on `RTMAPIEvent` with a ton of 
        //if/else clauses depending on the `type` of event
        //
        
        let builders: [String: RTMAPIEventBuilder.Type] = [
            ErrorBuilder.eventType: ErrorBuilder.self,
            PingPongBuilder.eventType: PingPongBuilder.self,
            ReconnectURLBuilder.eventType: ReconnectURLBuilder.self,
            PresenceChangeBuilder.eventType: PresenceChangeBuilder.self,
            HelloBuilder.eventType: HelloBuilder.self,
            UserTypingBuilder.eventType: UserTypingBuilder.self,
            MessageBuilder.eventType: MessageBuilder.self,
            ReactionAddedBuilder.eventType: ReactionAddedBuilder.self,
            ReactionRemovedBuilder.eventType: ReactionRemovedBuilder.self,
            UserChangeBuilder.eventType: UserChangeBuilder.self,
        ]
        
        guard
            let type = json["type"]?.string,
            let builder = builders[type]
            else {
                print(json) //TODO remove once all builders are built
                throw RTMAPIEventBuilderError.NoAvailableBuilder(type: json["type"]?.string ?? "no_type")
        }
        
        return builder
    }
}
