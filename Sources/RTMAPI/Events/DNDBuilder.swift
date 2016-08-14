import Models

private enum DNDEvent: String, RTMAPIEventBuilderEventType {
    case dnd_updated, dnd_updated_user
    
    static var all: [DNDEvent] { return [.dnd_updated, .dnd_updated_user] }
}

/// Handler for the dnd events
struct DNDBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return DNDEvent.all.map({ $0.rawValue }) }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard let event = DNDEvent.eventType(fromJson: json)
            else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        let user: User = try builder.lookup("user")
        let status: DNDStatus = try builder.model("dnd_status")
        
        switch event {
        case .dnd_updated:      return .dnd_updated(user: user, status: status)
        case .dnd_updated_user: return .dnd_updated_user(user: user, status: status)
        }
    }
}
