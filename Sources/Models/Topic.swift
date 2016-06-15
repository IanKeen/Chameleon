//
//  Topic.swift
// Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public struct Topic {
    public let value: String
    public let creator: User?
    public let last_set: Int
}

extension Topic: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Topic {
        return try tryMake(Topic(
            value:      try builder.property("value"),
            creator:    try builder.optionalSlackModel("creator"),
            last_set:   try builder.property("last_set")
            )
        )
    }
}
