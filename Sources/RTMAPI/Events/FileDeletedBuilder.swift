//
//  FileDeletedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 20/07/2016.
//
//

import Models
import Vapor

/// Handler for the `file_deleted` event
struct FileDeletedBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["file_deleted"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .file_deleted(
            fileId: try builder.property("file_id"),
            timestamp: try builder.property("event_ts")
        )
    }
}
