//
//  Team.swift
// Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public struct Team {
    public let id: String
    public let name: String
    public let domain: String
    
    public let image_default: Bool
    public let image_34: String?
    public let image_44: String?
    public let image_68: String?
    public let image_88: String?
    public let image_102: String?
    public let image_132: String?
}

extension Team: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> Team {
        return try tryMake(Team(
            id:             try builder.property("id"),
            name:           try builder.property("name"),
            domain:         try builder.property("domain"),
            image_default:  builder.property("icon.image_default"),
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
