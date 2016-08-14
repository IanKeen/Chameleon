
extension DNDStatus: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> DNDStatus {
        return try tryMake(builder, DNDStatus(
            dnd_enabled:        builder.default("dnd_enabled"),
            next_dnd_start_ts:  try builder.property("next_dnd_start_ts"),
            next_dnd_end_ts:    try builder.property("next_dnd_end_ts"),
            snooze_enabled:     builder.default("snooze_enabled"),
            snooze_endtime:     builder.optionalProperty("snooze_endtime")
            )
        )
    }
}
