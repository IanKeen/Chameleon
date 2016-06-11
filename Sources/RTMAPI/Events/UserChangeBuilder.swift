//
//  UserChangeBuilder.swift
//  Slack
//
//  Created by Ian Keen on 25/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal struct UserChangeBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "user_change" }
    
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(json: json) else { throw RTMAPIEventBuilderError.InvalidBuilder }
        
        let builder = builderFactory(json: json)
        
        return .user_change(user: try builder.property("user"))
    }
}
