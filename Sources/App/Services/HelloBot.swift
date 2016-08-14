import Bot
import SlackSugar

final class HelloBot: SlackMessageService {
    override func message(slackBot: SlackBot, webApi: WebAPI, message: MessageDecorator, previous: MessageDecorator?) throws {
        let greetings = ["hello", "hi", "hey"]
        guard
            let target = message.target, let sender = message.sender
            else { return }
        
        if (message.text.hasPrefix(options: greetings) && message.mentioned_users.contains(slackBot.me)) {
            let message = SlackMessage(target: target)
                .text("hey, ").user(sender)
            
            try webApi.execute(message.apiMethod())
        }
    }
}

extension String {
    func hasPrefix(options: [String]) -> Bool {
        for option in options where self.hasPrefix(option) {
            return true
        }
        return false
    }
}
