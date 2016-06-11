//
//  BotUser.swift
//  Slack
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public struct BotUser {
    public let id: String
    public let name: String
}

extension BotUser: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> BotUser {
        return try tryMake(BotUser(
            id:     try builder.property("id"),
            name:   try builder.property("name")
            )
        )
    }
}
