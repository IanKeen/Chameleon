//
//  FileSharedBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 20/07/2016.
//
//

import Models
import Vapor

/// Handler for the `file_shared` event
struct FileSharedBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "file_shared" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .file_shared(file: try builder.property("file"))
    }
}
