//
//  RTMAPIEvent+Builders.swift
//  Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

//MARK: - Protocol
/// An abstraction representing an object capable of building a realtime messaging api event
protocol RTMAPIEventBuilder {
    /// The name of the event `type` this object builds
    static var eventType: String { get }
    
    /**
     Defines if this object is capable of creating a `RTMAPIEvent` from the provided `JSON`
     
     - parameter json: The `JSON` to handle
     - returns: If the object can build a `RTMAPIEvent` `true`, otherwise `false`
     */
    static func canMake(fromJson json: JSON) -> Bool
    
    /**
     Creates a `RTMAPIEvent` from the provided `JSON`
     
     - parameter json:           The `JSON` used to build the `RTMAPIEvent`
     - parameter builderFactory: A function that can be called to create a `SlackModelBuilder` to obtain model objects needed for the event
     - throws: A `RTMAPIEventBuilderError` with failure details
     - returns: A new `RTMAPIEvent` instance
     */
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent
}

//MARK: - Default Implementation
extension RTMAPIEventBuilder {
    static func canMake(fromJson json: JSON) -> Bool {
        guard let event = json["type"]?.string else { return false }
        return (event == self.eventType)
    }
}

//MARK: - Errors
/// Describes a range of errors that can occur when attempting to build models from `JSON`
enum RTMAPIEventBuilderError: ErrorProtocol {
    /// No builder for the provided type exists
    case noAvailableBuilder(type: String)
    
    /// The builder in not capable of handling the provided `JSON`
    case invalidBuilder(builder: RTMAPIEventBuilder.Type)
    
    /// The response was invalid or the data was unexpected
    case invalidResponse(json: JSON)
}

//MARK: - Helpers
extension RTMAPIEvent {
    /**
     Finds a `RTMAPIEventBuilder` that can be used to create a `RTMAPIEvent` from the provided `JSON`
     
     - parameter json: The `JSON` representing the event
     - throws: A `RTMAPIEventBuilderError` with failure details
     - returns: A `RTMAPIEventBuilder` to build the event
     */
    static func makeEventBuilder(withJson json: JSON) throws -> RTMAPIEventBuilder.Type {
        
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
            ChannelMarkedBuilder.eventType: ChannelMarkedBuilder.self,
            ChannelCreatedBuilder.eventType: ChannelCreatedBuilder.self,
            ChannelJoinedBuilder.eventType: ChannelJoinedBuilder.self,
            ChannelLeftBuilder.eventType: ChannelLeftBuilder.self,
            ChannelDeletedBuilder.eventType: ChannelDeletedBuilder.self,
            ChannelRenameBuilder.eventType: ChannelRenameBuilder.self,
            ChannelArchiveBuilder.eventType: ChannelArchiveBuilder.self,
            ChannelUnarchiveBuilder.eventType: ChannelUnarchiveBuilder.self,
            DNDUpdatedBuilder.eventType: DNDUpdatedBuilder.self,
            DNDUpdatedUserBuilder.eventType: DNDUpdatedUserBuilder.self,
            IMCreatedBuilder.eventType: IMCreatedBuilder.self,
            IMOpenBuilder.eventType: IMOpenBuilder.self,
            IMCloseBuilder.eventType: IMCloseBuilder.self,
            IMMarkedBuilder.eventType: IMMarkedBuilder.self,
            GroupJoinedBuilder.eventType: GroupJoinedBuilder.self,
            GroupLeftBuilder.eventType: GroupLeftBuilder.self,
            GroupOpenBuilder.eventType: GroupOpenBuilder.self,
            GroupCloseBuilder.eventType: GroupCloseBuilder.self,
            GroupArchiveBuilder.eventType: GroupArchiveBuilder.self,
            GroupUnarchiveBuilder.eventType: GroupUnarchiveBuilder.self,
            GroupRenameBuilder.eventType: GroupRenameBuilder.self,
            GroupMarkedBuilder.eventType: GroupMarkedBuilder.self,
            FileCreatedBuilder.eventType: FileCreatedBuilder.self,
        ]
        
        guard
            let type = json["type"]?.string,
            let builder = builders[type]
            else {
                print("Missing Builder: \(json["type"]?.string ?? "")\n")
                print(json) //TODO remove once all builders are built
                print("\n")
                throw RTMAPIEventBuilderError.noAvailableBuilder(type: json["type"]?.string ?? "no type provided")
        }
        
        return builder
    }
}
