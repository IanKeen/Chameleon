//
//  Team+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension Team: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Team {
        return try tryMake(Team(
            id:             try builder.property("id"),
            name:           try builder.property("name"),
            domain:         try builder.property("domain"),
            image_default:  builder.default("icon.image_default"),
            image_34:       builder.optionalProperty("icon.image_34"),
            image_44:       builder.optionalProperty("icon.image_44"),
            image_68:       builder.optionalProperty("icon.image_68"),
            image_88:       builder.optionalProperty("icon.image_88"),
            image_102:      builder.optionalProperty("icon.image_102"),
            image_132:      builder.optionalProperty("icon.image_132")
            )
        )
    }
}
