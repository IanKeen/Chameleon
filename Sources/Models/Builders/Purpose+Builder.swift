//
//  Purpose+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension Purpose: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Purpose {
        return try tryMake(Purpose(
            value:      try builder.property("value"),
            creator:    try builder.optionalLookup("creator"),
            last_set:   try builder.property("last_set")
            )
        )
    }
}
