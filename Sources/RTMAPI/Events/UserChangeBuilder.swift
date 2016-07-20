//
//  UserChangeBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 25/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Vapor

/// Handler for the `user_change` event
struct UserChangeBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "user_change" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .user_change(user: try builder.property("user"))
    }
}
