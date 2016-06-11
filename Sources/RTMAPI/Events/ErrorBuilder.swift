//
//  ErrorBuilder.swift
//  Slack
//
//  Created by Ian Keen on 24/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal struct ErrorBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "error" }
    
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(json: json) else { throw RTMAPIEventBuilderError.InvalidBuilder }
        
        let builder = builderFactory(json: json)
        
        return .error(
            code: try builder.property("error.code"),
            message: try builder.property("error.msg")
        )
    }
}
