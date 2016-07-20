//
//  IMCreatedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

import Models
import Vapor

/// Handler for the `im_created` event
struct IMCreatedBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["im_created"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .im_created(
            user: try builder.slackModel("user"),
            im: try builder.property("channel")
        )
    }
}
