//
//  GroupBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 20/07/2016.
//
//

import Models

private enum GroupEvent: String, RTMAPIEventBuilderEventType {
    case
    group_archive, group_close, group_joined, group_left,
    group_marked, group_open, group_unarchive
    
    static var all: [GroupEvent] {
        return [.group_archive, .group_close, .group_joined, .group_left,
                .group_marked, .group_open, .group_unarchive]
    }
}

/// Handler for the group events
struct GroupBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return GroupEvent.all.map({ $0.rawValue }) }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard let event = GroupEvent.eventType(fromJson: json)
            else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        switch event {
        case .group_archive:
            return .group_archive(group: try builder.lookup("channel"))
        case .group_close:
            return .group_close(
                user: try builder.lookup("user"),
                group: try builder.lookup("channel")
            )
        case .group_joined:
            return .group_joined(group: try builder.model("channel"))
        case .group_left:
            return .group_left(group: try builder.lookup("channel"))
        case .group_marked:
            return .group_marked(
                group: try builder.lookup("channel"),
                timestamp: try builder.property("ts")
            )
        case .group_open:
            return .group_open(
                user: try builder.lookup("user"),
                group: try builder.lookup("channel")
            )
        case .group_unarchive:
            return .group_unarchive(group: try builder.lookup("channel"))
        }
    }
}
