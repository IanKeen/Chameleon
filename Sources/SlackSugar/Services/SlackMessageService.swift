import Bot

public class SlackMessageService: SlackRTMEventService {
    public init() { }
    
    public func event(slackBot: SlackBot, event: RTMAPIEvent, webApi: WebAPI) throws {
        switch event {
        case .message(let message, let previous):
            try self.message(
                slackBot: slackBot,
                webApi: webApi,
                message: message.makeDecorator(slackModels: slackBot.currentSlackModelData),
                previous: previous?.makeDecorator(slackModels: slackBot.currentSlackModelData)
            )
        default: break
        }
    }
    
    public func message(slackBot: SlackBot, webApi: WebAPI, message: MessageDecorator, previous: MessageDecorator?) throws {
        //Override...
    }
}
