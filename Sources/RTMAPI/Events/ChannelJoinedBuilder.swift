//
//  ChannelJoinedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

import Models
import Vapor

/// Handler for the `channel_joined` event
struct ChannelJoinedBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["channel_joined"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .channel_joined(channel: try builder.property("channel"))
    }
}
