
extension Reaction: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> Reaction {
        return try tryMake(builder, Reaction(
            name:   try builder.property("name"),
            count:  try builder.property("count"),
            users:  try builder.lookup("users")
            )
        )
    }
}
