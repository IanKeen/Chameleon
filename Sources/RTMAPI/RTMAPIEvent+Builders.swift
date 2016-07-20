//
//  RTMAPIEvent+Builders.swift
//  Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Vapor
import Common

//MARK: - Protocol
/// An abstraction representing an object capable of building a realtime messaging api event
protocol RTMAPIEventBuilder {
    /// The name of the event `type` this object builds
    static var eventTypes: [String] { get }
    
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
        guard let event = json["type"].string else { return false }
        return (self.eventTypes.contains(event))
    }
}

//MARK: - Errors
/// Describes a range of errors that can occur when attempting to build models from `JSON`
public enum RTMAPIEventBuilderError: ErrorProtocol, CustomStringConvertible {
    /// No builder for the provided type exists
    case noAvailableBuilder(type: String)
    
    /// The builder in not capable of handling the provided `JSON`
    case invalidBuilder(builder: Any.Type)
    
    /// The response was invalid or the data was unexpected
    case invalidResponse(json: JSON)
    
    public var description: String {
        switch self {
        case .invalidBuilder(let builder):
            return "The chosen builder: '\(String(builder.self))' cannot handled to provided data"
        case .invalidResponse(let json):
            return "The response was invalid:\n\(json.jsonValueDescription)"
        case .noAvailableBuilder(let type):
            return "There is no builder available for the event-type: \(type)"
        }
    }
}

//MARK: - Helpers
extension RTMAPIEvent {
    
    //Add builders here:
    //
    //The idea here is to break out the 'building' of all the slack events
    //in an attempt to manage their creation a little easier
    //rather than a single `init(json:)` on `RTMAPIEvent` with a ton of
    //if/else clauses depending on the `type` of event
    //
    
    //TODO: there is a lot of repeted code in the builders (mostly between builders of the same type i.e. 'file')
    //      consider a new mechanism allowing a builder to support multiple events but keep the lookup fast
    //
    //      builders could return a [String] of supported event types
    //      and this dict could be generated into a flattened representation
    //      still providing an O(1) lookup (make this dict a 1 time generated structure)
    
    private static var builders: [String: RTMAPIEventBuilder.Type] = {
        
        let builders: [RTMAPIEventBuilder.Type] = [
            ErrorBuilder.self,
            PingPongBuilder.self,
            ReconnectURLBuilder.self,
            PresenceChangeBuilder.self,
            HelloBuilder.self,
            UserTypingBuilder.self,
            MessageBuilder.self,
            ReactionAddedBuilder.self,
            ReactionRemovedBuilder.self,
            UserChangeBuilder.self,
            ChannelMarkedBuilder.self,
            ChannelCreatedBuilder.self,
            ChannelJoinedBuilder.self,
            ChannelLeftBuilder.self,
            ChannelDeletedBuilder.self,
            ChannelRenameBuilder.self,
            ChannelArchiveBuilder.self,
            ChannelUnarchiveBuilder.self,
            DNDUpdatedBuilder.self,
            DNDUpdatedUserBuilder.self,
            IMCreatedBuilder.self,
            IMOpenBuilder.self,
            IMCloseBuilder.self,
            IMMarkedBuilder.self,
            GroupJoinedBuilder.self,
            GroupLeftBuilder.self,
            GroupOpenBuilder.self,
            GroupCloseBuilder.self,
            GroupArchiveBuilder.self,
            GroupUnarchiveBuilder.self,
            GroupRenameBuilder.self,
            GroupMarkedBuilder.self,
            FileCreatedBuilder.self,
            FileSharedBuilder.self,
            FileUnsharedBuilder.self,
            FilePublicBuilder.self,
            FilePrivateBuilder.self,
            FileChangeBuilder.self,
            FileDeletedBuilder.self,
            FileCommentAddedBuilder.self,
            FileCommentEditedBuilder.self,
            FileCommentDeletedBuilder.self,
            ]
        
        let entries = builders.flatMap { builder -> [[String: RTMAPIEventBuilder.Type]] in
            return builder.eventTypes.flatMap { eventType in
                return [eventType: builder]
            }
        }
        
        var result = [String: RTMAPIEventBuilder.Type]()
        for entry in entries {
            result = result + entry
        }
        return result
    }()
    
    /**
     Finds a `RTMAPIEventBuilder` that can be used to create a `RTMAPIEvent` from the provided `JSON`
     
     - parameter json: The `JSON` representing the event
     - throws: A `RTMAPIEventBuilderError` with failure details
     - returns: A `RTMAPIEventBuilder` to build the event
     */
    static func makeEventBuilder(withJson json: JSON) throws -> RTMAPIEventBuilder.Type {
        guard
            let type = json["type"].string,
            let builder = self.builders[type]
            else {
                print("Missing Builder: \(json["type"].string ?? "")\n")
                print(json) //TODO remove once all builders are built
                print("\n")
                throw RTMAPIEventBuilderError.noAvailableBuilder(type: json["type"].string ?? "no type provided")
        }
        
        return builder
    }
}
