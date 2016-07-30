//
//  SlackMessageBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 6/06/2016.
//
//

import Models
import WebAPI
import Foundation

/// A builder to make creating Slack messages easier
public final class SlackMessage {
    //MARK: - Private Properties
    private let target: Target
    private let options: [ChatPostMessage.Option]
    private var messageSegments = [String]()
    
    //MARK: - Lifecycle
    /**
     Create a new `SlackMessage`
     
     - parameter target:  The `Target` the message will be sent to
     - parameter options: A sequence of `ChatPostMessage.Option`s to use for the message (optional)
     
     - returns: A new `SlackMessage` instance
     */
    public init(target: Target, options: [ChatPostMessage.Option] = []) {
        self.target = target
        self.options = options
    }
    
    //MARK: - Public
    /**
     Add a `String` component
     
     - parameter value:         The `String` value to add
     - parameter formatting:    The `SlackMessage.Formatting` to use (defaults to `.None`)
     - parameter trailingSpace: Whether a trailing space should be added (defaults to `true`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func text(_ value: String, formatting: Formatting = .none, trailingSpace: Bool = true) -> SlackMessage {
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
     
     - parameter value:         The `NSURL` to link
     - parameter trailingSpace: Whether a trailing space should be added (defaults to `true`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func url(_ value: NSURL, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value(value.absoluteString!, trailingSpace: trailingSpace)]
        return self
    }
    
    /**
     Add a Slack command component
     
     - parameter value:         The `SlackMessage.Command` to add
     - parameter trailingSpace: Whether a trailing space should be added (defaults to `true`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func command(_ value: Command, trailingSpace: Bool = true) -> SlackMessage {
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
public extension SlackMessage {
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
private extension SlackMessage {
    private func value(_ string: String, trailingSpace: Bool) -> String {
        return "\(string)\(trailingSpace ? " " : "")"
    }
}

//MARK: - SlackMessage.Command
public extension SlackMessage {
    /// Represents the available Slack commands
    public enum Command {
        /// Mention @channel
        case channel
        
        /// Mention @group
        case group
        
        /// Mention @here
        case here
        
        /// Mention @everyone
        case everyone
        
        /// Mention a specific user group
        case userGroup(id: String, name: String) //TODO: replace these params with a `UserGroup` object
        
        /// Custom mention
        case custom(name: String)
        
        private var command: String {
            switch self {
            case .channel: return "!channel"
            case .group: return "!group"
            case .here: return "!here"
            case .everyone: return "!everyone"
            case .userGroup(let id, let name): return "!subteam^\(id)|\(name)"
            case .custom(let name): return "!\(name)"
            }
        }
    }
}

//MARK: - SlackMessage.Formatting
public extension SlackMessage {
    /// Represents the available message formatting for text
    public enum Formatting {
        /// Leave the text 'as-is'
        case none
        
        /// Place the text in a pre block
        case pre
        
        /// Use inline code formatting
        case code
        
        /// Use italics
        case italic
        
        /// Use bold
        case bold
        
        /// Use strikethrough
        case strike
        
        private func formattedText(_ value: String) -> String {
            switch self {
            case .none: return value
            case .pre: return "```\(value)```"
            case .code: return "`\(value)`"
            case .italic: return "_\(value)_"
            case .bold: return "*\(value)*"
            case .strike: return "~\(value)~"
            }
        }
    }
}
