//
//  Message_Reaction+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

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
