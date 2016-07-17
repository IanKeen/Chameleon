//
//  ChannelLeftBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

import Models
import Jay

/// Handler for the `channel_left` event
struct ChannelLeftBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "channel_left" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .channel_left(channel: try builder.slackModel("channel"))
    }
}
