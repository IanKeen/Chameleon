//
//  IMCloseBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

import Models
import Vapor

/// Handler for the `im_close` event
struct IMCloseBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "im_close" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .im_close(
            user: try builder.slackModel("user"),
            im: try builder.slackModel("channel")
        )
    }
}
