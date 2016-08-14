import Models
import Common

//MARK: - Protocol
/// An abstraction representing an object capable of building a realtime messaging api event
public protocol RTMAPIEventBuilder {
    /// The name of the event `type`s this object builds
    static var eventTypes: [String] { get }
    
    /**
     Creates a `RTMAPIEvent` from the provided `[String: Any]`
     
     - parameter json:           The `[String: Any]` used to build the `RTMAPIEvent`
     - parameter builderFactory: A function that can be called to create a `SlackModelBuilder` to obtain model objects needed for the event
     - throws: A `RTMAPIEventBuilderError` with failure details
     - returns: A new `RTMAPIEvent` instance
     */
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent
}

/// A simple protocol that can be used in builders to handle multiple events in a type-safe way
protocol RTMAPIEventBuilderEventType: RawRepresentable {
    static var all: [Self] { get }
}
extension RTMAPIEventBuilderEventType where RawValue == String {
    static func eventType(fromJson json: [String: Any]) -> Self? {
        guard let event = json["type"] as? String else { return nil }
        return Self(rawValue: event)
    }
}


//MARK: - Default Implementation
extension RTMAPIEventBuilder {
    /**
     Defines if this object is capable of creating a `RTMAPIEvent` from the provided `[String: Any]`
     
     - parameter json: The `[String: Any]` to handle
     - returns: If the object can build a `RTMAPIEvent` `true`, otherwise `false`
     */
    static func canMake(fromJson json: [String: Any]) -> Bool {
        guard let event = json["type"] as? String else { return false }
        return (self.eventTypes.contains(event))
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
    
    private static var builders: [String: RTMAPIEventBuilder.Type] = {
        let builders: [RTMAPIEventBuilder.Type] = [
            ErrorBuilder.self,
            PingPongBuilder.self,
            ReconnectURLBuilder.self,
            PresenceChangeBuilder.self,
            HelloBuilder.self,
            UserTypingBuilder.self,
            MessageBuilder.self,
            ReactionBuilder.self,
            UserChangeBuilder.self,
            ChannelBuilder.self,
            ChannelRenameBuilder.self,
            DNDBuilder.self,
            IMBuilder.self,
            GroupBuilder.self,
            GroupRenameBuilder.self,
            FileBuilder.self,
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
     Finds a `RTMAPIEventBuilder` that can be used to create a `RTMAPIEvent` from the provided `[String: Any]`
     
     - parameter json: The `[String: Any]` representing the event
     - throws: A `RTMAPIEventBuilderError` with failure details
     - returns: A `RTMAPIEventBuilder` to build the event
     */
    static func makeEventBuilder(withJson json: [String: Any]) throws -> RTMAPIEventBuilder.Type {
        guard
            let type = json["type"] as? String,
            let builder = self.builders[type]
            else {
                print("Missing Builder: \((json["type"] as? String) ?? "")\n")
                print(json) //TODO remove once all builders are built
                print("\n")
                throw RTMAPIEventBuilderError.noAvailableBuilder(type: (json["type"] as? String) ?? "no type provided")
        }
        
        return builder
    }
}
