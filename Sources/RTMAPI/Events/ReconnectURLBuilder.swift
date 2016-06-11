//
//  ReconnectURLBuilder.swift
//  Slack
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Jay

internal struct ReconnectURLBuilder: RTMAPIEventBuilder {
    static var eventType: String { return "reconnect_url" }
    
    static func make(json: JSON, builderFactory: (json: JSON) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(json: json) else { throw RTMAPIEventBuilderError.InvalidBuilder }
        
        return .reconnect_url(url: json["url"]?.string ?? "")
    }
}