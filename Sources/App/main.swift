import Bot

let bot = try SlackBot(
    configDataSource: DefaultConfigDataSource,
    authenticator: TokenAuthentication.self,
    storage: MemoryStorage.self,
    services: [HelloBot()]
)

bot.start()
