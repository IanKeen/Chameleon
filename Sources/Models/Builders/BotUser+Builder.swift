//
//  BotUser+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension BotUser: SlackModelType {
    public static func make(with builder: SlackModelBuilder) throws -> BotUser {
        return try tryMake(BotUser(
            id:     try builder.property("id"),
            name:   try builder.property("name")
            )
        )
    }
}
