//
//  Message_Edit+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension Message.Edit: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Message.Edit {
        return try tryMake(builder, Message.Edit(
            user:       try builder.model("user"),
            timestamp:  try builder.property("ts")
            )
        )
    }
}
