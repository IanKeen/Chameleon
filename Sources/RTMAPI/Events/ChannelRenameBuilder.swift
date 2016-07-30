//
//  ChannelRenameBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

import Models

/// Handler for the `channel_rename` event
struct ChannelRenameBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["channel_rename"] }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        var channel: Channel = try builder.lookup("channel.id")
        let oldName = channel.name
        
        let newName: String = try builder.property("channel.name")
        channel = channel.renamed(to: newName)
        
        return .channel_rename(channel: channel, oldName: oldName)
    }
}
