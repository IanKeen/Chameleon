//
//  FileCommentEditedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 20/07/2016.
//
//

import Models
import Vapor

/// Handler for the `file_comment_edited` event
struct FileCommentEditedBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["file_comment_edited"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .file_comment_edited(
            file: try builder.property("file"),
            comment: ""//try builder.property("event_ts")
        )
    }
}
