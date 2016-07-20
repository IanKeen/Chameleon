//
//  Topic+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension Topic: SlackModelType {
    public static func make(with builder: SlackModelBuilder) throws -> Topic {
        return try tryMake(Topic(
            value:      try builder.property("value"),
            creator:    try builder.optionalSlackModel("creator"),
            last_set:   try builder.property("last_set")
            )
        )
    }
}
