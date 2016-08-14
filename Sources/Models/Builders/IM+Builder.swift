
extension IM: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> IM {
        return try tryMake(builder, IM(
            id:                 try builder.property("id"),
            is_im:              builder.default("is_im"),
            is_open:            builder.default("is_open"),
            has_pins:           builder.default("has_pins"),
            user:               try builder.lookup("user"),
            created:            builder.property("created"),
            is_user_deleted:    builder.default("is_user_deleted"),
            last_read:          builder.property("last_read"),
            latest:             try? builder.model("latest")
            )
        )
    }
}
