import Models

/// Handler for the `hello` event
struct HelloBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["hello"] }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        return .hello
    }
}
