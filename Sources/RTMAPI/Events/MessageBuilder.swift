//
//  MessageBuilder.swift
//  Slack
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal struct MessageBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "message" }
    
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(json: json) else { throw RTMAPIEventBuilderError.InvalidBuilder }
        
        //edits contain the message as a nested item :\
        let previousMessageJson = json["message"]
        let messageJson = previousMessageJson ?? json
        
        let builder = builderFactory(json: messageJson)
        let previousBuilder = builderFactory(json: previousMessageJson ?? JSON.null)
        
        return .message(
            message: try Message.make(builder: builder),
            previous: try? Message.make(builder: previousBuilder)
        )
    }
}
