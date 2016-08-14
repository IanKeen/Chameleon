import Models

/// Handler for the `message` event
struct MessageBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["message"] }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        //edits contain the message as a nested item :\
        let previousMessageJson = json["message"] as? [String: Any]
        let messageJson = previousMessageJson ?? json
        
        let builder = builderFactory(json: messageJson)
        let previousBuilder = builderFactory(json: previousMessageJson ?? [:])
        
        return .message(
            message: try Message.makeModel(with: builder),
            previous: try? Message.makeModel(with: previousBuilder)
        )
    }
}
