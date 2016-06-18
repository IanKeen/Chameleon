//
//  IM+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

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
