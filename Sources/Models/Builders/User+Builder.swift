//
//  User+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension User: SlackModelType {
    public static func make(with builder: SlackModelBuilder) throws -> User {
        return try tryMake(User(
            id:                     try builder.property("id"),
            bot_id:                 builder.optionalProperty("profile.bot_id"),
            team_id:                try builder.property("team_id"),
            name:                   try builder.property("name"),
            real_name:              builder.optionalProperty("real_name"),
            status:                 builder.optionalProperty("status"),
            presence:               builder.optionalProperty("presence"),
            title:                  builder.optionalProperty("profile.title"),
            image_24:               builder.optionalProperty("profile.image_24"),
            image_32:               builder.optionalProperty("profile.image_32"),
            image_48:               builder.optionalProperty("profile.image_48"),
            image_72:               builder.optionalProperty("profile.image_72"),
            image_192:              builder.optionalProperty("profile.image_192"),
            image_512:              builder.optionalProperty("profile.image_512"),
            is_bot:                 builder.property("is_bot"),
            is_admin:               builder.property("is_admin"),
            is_owner:               builder.property("is_owner"),
            is_primary_owner:       builder.property("is_primary_owner"),
            is_restricted:          builder.property("is_restricted"),
            is_ultra_restricted:    builder.property("is_ultra_restricted")
            )
        )
    }
}
