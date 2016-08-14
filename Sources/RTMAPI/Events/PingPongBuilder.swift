import Models

/// Handler for the `pong` event
struct PingPongBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["pong"] }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        return .pong(response: json)
    }
}
