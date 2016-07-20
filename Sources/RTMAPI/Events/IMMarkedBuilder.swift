//
//  IMMarkedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

import Models
import Vapor

/// Handler for the `im_marked` event
struct IMMarkedBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["im_marked"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .im_marked(
            im: try builder.slackModel("channel"),
            timestamp: try builder.property("ts")
        )
    }
}
