//
//  FileCreatedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

import Models
import Vapor

/// Handler for the `file_created` event
struct FileCreatedBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["file_created"] }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .file_created(file: try builder.property("file"))
    }
}
