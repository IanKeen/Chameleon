//
//  UserTypingBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Vapor

/// Handler for the `user_typing` event
struct UserTypingBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["user_typing"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        return .user_typing(
            user: try builder.slackModel("user"),
            target: try builder.slackModel("channel")
        )
    }
}
