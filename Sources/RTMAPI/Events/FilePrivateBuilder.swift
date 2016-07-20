//
//  FilePrivateBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 20/07/2016.
//
//

import Models
import Vapor

/// Handler for the `file_private` event
struct FilePrivateBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "file_private" }
    
    static func make(withJson json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        return .file_private(fileId: try builder.property("file"))
    }
}
