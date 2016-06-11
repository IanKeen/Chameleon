//
//  Purpose.swift
//  Slack
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public struct Purpose {
    public let value: String
    public let creator: User?
    public let last_set: Int
}

extension Purpose: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Purpose {
        return try tryMake(Purpose(
            value:      try builder.property("value"),
            creator:    try builder.optionalSlackModel("creator"),
            last_set:   try builder.property("last_set")
            )
        )
    }
}
