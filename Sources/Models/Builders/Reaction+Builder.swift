//
//  Reaction+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension Reaction: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Reaction {
        return try tryMake(Reaction(
            name:   try builder.property("name"),
            count:  try builder.property("count"),
            users:  try builder.slackModels("users")
            )
        )
    }
}
