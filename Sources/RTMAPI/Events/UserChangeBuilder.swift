import Models

/// Handler for the `user_change` event
struct UserChangeBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["user_change"] }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .user_change(user: try builder.model("user"))
    }
}
