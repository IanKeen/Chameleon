import Bot

private final class Logger: SlackRTMEventService {
    private func event(slackBot: SlackBot, event: RTMAPIEvent, webApi: WebAPI) throws {
        if case .pong = event { return }
        print(event)
    }
}

let bot = try SlackBot(
    configDataSource: DefaultConfigDataSource,
    authenticator: TokenAuthentication.self, //OAuthAuthentication.self,
    storage: MemoryStorage.self,
    services: [HelloBot(), Logger()]
)

bot.start()
