//
//  IM.swift
// Chameleon
//
//  Created by Ian Keen on 25/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public struct IM {
    public let id: String
    public let is_im: Bool
    public let is_open: Bool
    public let has_pins: Bool
    public let user: User
    public let created: Double
    public let is_user_deleted: Bool
    public let last_read: String
    public let latest: Message?
}

extension IM: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> IM {
        return try tryMake(IM(
            id:                 try builder.property("id"),
            is_im:              builder.property("is_im"),
            is_open:            builder.property("is_open"),
            has_pins:           builder.property("has_pins"),
            user:               try builder.slackModel("user"),
            created:            builder.property("created"),
            is_user_deleted:    builder.property("is_user_deleted"),
            last_read:          builder.property("last_read"),
            latest:             try builder.optionalProperty("latest")
            )
        )
    }
}
