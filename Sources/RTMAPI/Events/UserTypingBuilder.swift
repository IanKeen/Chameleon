//
//  UserTypingBuilder.swift
//  Slack
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal struct UserTypingBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "user_typing" }
    
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(json: json) else { throw RTMAPIEventBuilderError.InvalidBuilder }
        
        let builder = builderFactory(json: json)
        return .user_typing(
            user: try builder.slackModel("user"),
            target: try builder.slackModel("channel")
        )
    }
}
