//
//  ChannelDeletedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

import Models
import Jay

/// Handler for the `channel_deleted` event
struct ChannelDeletedBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "channel_deleted" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .channel_deleted(channel: try builder.slackModel("channel"))
    }
}
