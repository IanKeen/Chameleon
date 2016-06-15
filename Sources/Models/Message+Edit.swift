//
//  Message+Edit.swift
// Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public extension Message {
    public struct Edit {
        public let user: User
        public let timestamp: String
    }
}

extension Message.Edit: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Message.Edit {
        return try tryMake(Message.Edit(
            user:       try builder.slackModel("user"),
            timestamp:  try builder.property("ts")
            )
        )
    }
}
