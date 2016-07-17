//
//  DNDStatus+Builder.swift
//  Chameleon
//
//  Created by Ian Keen on 16/07/2016.
//
//

extension DNDStatus: SlackModelType {
    public static func make(builder: SlackModelBuilder) throws -> DNDStatus {
        return try tryMake(DNDStatus(
            dnd_enabled:        builder.property("dnd_enabled"),
            next_dnd_start_ts:  try builder.property("next_dnd_start_ts"),
            next_dnd_end_ts:    try builder.property("next_dnd_end_ts"),
            snooze_enabled:     builder.property("snooze_enabled"),
            snooze_endtime:     builder.optionalProperty("snooze_endtime")
            )
        )
    }
}
