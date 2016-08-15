import Bot

private final class Logger: SlackRTMEventService {
    private func event(slackBot: SlackBot, event: RTMAPIEvent, webApi: WebAPI) throws {
        if case .pong = event { return }
        print(event)
    }
}
