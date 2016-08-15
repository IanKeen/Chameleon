import Bot
import Foundation

/// A builder to make creating Slack messages easier
public final class SlackMessage {
    //MARK: - Private Properties
    private let target: Target
    private let options: [ChatPostMessageOption]
    private var messageSegments = [String]()
    
    //MARK: - Lifecycle
    /**
     Create a new `SlackMessage`
     
     - parameter target:  The `Target` the message will be sent to
     - parameter options: A sequence of `ChatPostMessage.Option`s to use for the message (optional)
     
     - returns: A new `SlackMessage` instance
     */
    public init(target: Target, options: [ChatPostMessageOption] = [.linkNames(true)]) {
        self.target = target
        self.options = options
    }
    
    //MARK: - Public
    /**
     Add a `String` component
     
     - parameter value:         The `String` value to add
     - parameter formatting:    The `SlackMessageFormatting` to use (defaults to `.None`)
     - parameter trailingSpace: Whether a trailing space should be added (defaults to `true`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func text(_ value: String, formatting: SlackMessageFormatting = .None, trailingSpace: Bool = true) -> SlackMessage {
        let encodedText = value
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "&", with: "&amp;")
        self.messageSegments += [self.value(formatting.formattedText(encodedText), trailingSpace: trailingSpace)]
        return self
    }
    
    /**
     Add a mention link to a `User`
     
     - parameter value:         The `User` to mention
     - parameter trailingSpace: Whether a trailing space should be added (defaults to `true`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func user(_ value: User, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value("<@\(value.id)>", trailingSpace: trailingSpace)]
        return self
    }
    
    /**
     Add a mention link to a `Channel`
     
     - parameter value:         The `Channel` to mention
     - parameter trailingSpace: Whether a trailing space should be added (defaults to `true`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func channel(_ value: Channel, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value("<#\(value.id)>", trailingSpace: trailingSpace)]
        return self
    }
    
    /**
     Add a link to an `NSURL`
     
     - parameter value:         The `URL` to link
     - parameter trailingSpace: Whether a trailing space should be added (defaults to `true`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func url(_ value: URL, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value(value.absoluteString, trailingSpace: trailingSpace)]
        return self
    }
    
    /**
     Add a Slack command component
     
     - parameter value:         The `SlackMessageCommand` to add
     - parameter trailingSpace: Whether a trailing space should be added (defaults to `true`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func command(_ value: SlackMessageCommand, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value(value.command, trailingSpace: trailingSpace)]
        return self
    }
    
    /**
     Add a Slack emoji component
     
     - parameter value:         The `SlackEmoji` to add
     - parameter trailingSpace: Whether a trailing space should be added (defaults to `true`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func emoji(_ value: SlackEmoji, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value(value.emojiSymbol, trailingSpace: trailingSpace)]
        return self
    }
    
    /**
     Add a new line
     
     - returns: The updated `SlackMessage` instance
     */
    public func newLine() -> SlackMessage {
        self.messageSegments += ["\n"]
        return self
    }
}

//MARK: - SlackMessage > WebAPI.ChatPostMessage
extension SlackMessage {
    /// Create a `ChatPostMessage` from this instance to use with the `WebAPI`
    public func apiMethod() -> ChatPostMessage {
        return ChatPostMessage(
            target: self.target,
            text: self.messageSegments.joined(separator: ""),
            options: self.options,
            customParameters: nil,
            attachments: nil
        )
    }
}

//MARK: - Private Helpers
extension SlackMessage {
    private func value(_ string: String, trailingSpace: Bool) -> String {
        return "\(string)\(trailingSpace ? " " : "")"
    }
}

//MARK: - SlackMessageCommand
/// Represents the available Slack commands
public enum SlackMessageCommand {
    /// Mention @channel
    case Channel
    
    /// Mention @group
    case Group
    
    /// Mention @here
    case Here
    
    /// Mention @everyone
    case Everyone
    
    /// Mention a specific user group
    case UserGroup(id: String, name: String) //TODO: replace these params with a `UserGroup` object
    
    /// Custom mention
    case Custom(name: String)
    
    private var command: String {
        switch self {
        case .Channel: return "!channel"
        case .Group: return "!group"
        case .Here: return "!here"
        case .Everyone: return "!everyone"
        case .UserGroup(let id, let name): return "!subteam^\(id)|\(name)"
        case .Custom(let name): return "!\(name)"
        }
    }
}

//MARK: - SlackMessageFormatting
/// Represents the available message formatting for text
public enum SlackMessageFormatting {
    /// Leave the text 'as-is'
    case None
    
    /// Place the text in a pre block
    case Pre
    
    /// Use inline code formatting
    case Code
    
    /// Use italics
    case Italic
    
    /// Use bold
    case Bold
    
    /// Use strikethrough
    case Strike
    
    private func formattedText(_ value: String) -> String {
        switch self {
        case .None: return value
        case .Pre: return "```\(value)```"
        case .Code: return "`\(value)`"
        case .Italic: return "_\(value)_"
        case .Bold: return "*\(value)*"
        case .Strike: return "~\(value)~"
        }
    }
}

//MARK: - Operators
/**
 These are a set of optional operators to make constructing a `SlackMessage` made of lots of components a little more fluent
 Everything these operators do can be done with the `SlackMessage` object directly
 */

public func +(builder: SlackMessage, value: String) -> SlackMessage {
    return builder.text(value)
}
public func +(builder: SlackMessage, value: User) -> SlackMessage {
    return builder.user(value)
}
public func +(builder: SlackMessage, value: Channel) -> SlackMessage {
    return builder.channel(value)
}
public func +(builder: SlackMessage, value: URL) -> SlackMessage {
    return builder.url(value)
}
public func +(builder: SlackMessage, value: SlackMessageCommand) -> SlackMessage {
    return builder.command(value)
}
public func +(builder: SlackMessage, value: SlackEmoji) -> SlackMessage {
    return builder.emoji(value)
}
