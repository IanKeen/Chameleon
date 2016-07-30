//
//  ReconnectURLBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models

/// Handler for the `reconnect_url` event
struct ReconnectURLBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["reconnect_url"] }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        return .reconnect_url(url: (json["url"] as? String) ?? "")
    }
}
