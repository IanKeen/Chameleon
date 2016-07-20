//
//  DNDUpdatedUserBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

import Models
import Vapor

/// Handler for the `dnd_updated_user` event
struct DNDUpdatedUserBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["dnd_updated_user"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .dnd_updated_user(
            user: try builder.slackModel("user"),
            status: try builder.property("dnd_status")
        )
    }
}
