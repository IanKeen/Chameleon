//
//  Message+Reaction.swift
// Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public extension Message {
    public struct Reaction {
        public let name: String
        public let count: Int
        public let users: [User]
    }
}

extension Message.Reaction: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Message.Reaction {
        return try tryMake(Message.Reaction(
            name:   try builder.property("name"),
            count:  try builder.property("count"),
            users:  try builder.slackModels("users")
            )
        )
    }
}
