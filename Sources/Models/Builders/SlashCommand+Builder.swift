
extension SlashCommand: SlackModelType {
    public static func makeModel(with builder: SlackModelBuilder) throws -> SlashCommand {
        return try tryMake(builder, SlashCommand(
            token:          try builder.property("token"),
            team:           try builder.lookup("team_id"),
            team_domain:    try builder.property("team_domain"),
            channel:        try builder.lookup("channel_id"),
            channel_name:   try builder.property("channel_name"),
            user:           try builder.lookup("user_id"),
            user_name:      try builder.property("user_name"),
            command:        try builder.property("command"),
            text:           try builder.property("text"),
            response_url:   try builder.property("response_url")
            )
        )
    }
}
