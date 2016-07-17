//
//  GroupRenameBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

import Models
import Jay

/// Handler for the `group_rename` event
struct GroupRenameBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "group_rename" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        var group: Group = try builder.slackModel("channel.id")
        let oldName = group.name
        
        let newName: String = try builder.property("channel.name")
        group = group.renamed(to: newName)
        
        return .group_rename(group: group, oldName: oldName)
    }
}
