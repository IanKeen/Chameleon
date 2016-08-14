
extension BotUser: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> BotUser {
        return try tryMake(builder, BotUser(
            id:     try builder.property("id"),
            name:   try builder.property("name")
            )
        )
    }
}
