//
//  ChannelArchiveBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

import Models
import Vapor

/// Handler for the `channel_archive` event
struct ChannelArchiveBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["channel_archive"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .channel_archive(
            channel: try builder.slackModel("channel"),
            user: try builder.slackModel("user")
        )
    }
}
