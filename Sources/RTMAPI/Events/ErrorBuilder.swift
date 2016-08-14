import Models

/// Handler for the `error` event
struct ErrorBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["error"] }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .error(
            code: try builder.property("error.code"),
            message: try builder.property("error.msg")
        )
    }
}
