import Models

private enum IMEvent: String, RTMAPIEventBuilderEventType {
    case im_close, im_created, im_marked, im_open
    
    static var all: [IMEvent] { return [.im_close, .im_created, .im_marked, .im_open] }
}

/// Handler for the im events
struct IMBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return IMEvent.all.map({ $0.rawValue }) }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard let event = IMEvent.eventType(fromJson: json)
            else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        switch event {
        case .im_close:
            return .im_close(
                user: try builder.lookup("user"),
                im: try builder.lookup("channel")
            )
        case .im_created:
            return .im_created(
                user: try builder.lookup("user"),
                im: try builder.model("channel")
            )
        case .im_marked:
            return .im_marked(
                im: try builder.lookup("channel"),
                timestamp: try builder.property("ts")
            )
        case .im_open:
            return .im_open(
                user: try builder.lookup("user"),
                im: try builder.lookup("channel")
            )
        }
    }
}
