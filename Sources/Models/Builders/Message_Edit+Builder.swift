
extension MessageEdit: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> MessageEdit {
        return try tryMake(builder, MessageEdit(
            user:       try builder.model("user"),
            timestamp:  try builder.property("ts")
            )
        )
    }
}
