//
//  SlackMessageBuilder.swift
//  Slack
//
//  Created by Ian Keen on 6/06/2016.
//
//

import Models
import WebAPI
import Foundation

extension SlackMessage {
    public enum Command {
        case Channel
        case Group
        case Here
        case Everyone
        case UserGroup(id: String, name: String) //TODO: replace these params with a `UserGroup` object
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
}

extension SlackMessage {
    public enum Formatting {
        case None
        case Pre
        case Code
        case Italic
        case Bold
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
}

public final class SlackMessage {
    //MARK: - Private Properties
    private let target: Target
    private let options: [ChatPostMessage.Option]
    private var messageSegments = [String]()
    
    //MARK: - Lifecycle
    public init(target: Target, options: [ChatPostMessage.Option] = []) {
        self.target = target
        self.options = options
    }
    
    //MARK: - Public
    public func text(_ value: String, formatting: Formatting = .None, trailingSpace: Bool = true) -> SlackMessage {
        let encodedText = value
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "&", with: "&amp;")
        self.messageSegments += [self.value(formatting.formattedText(encodedText), trailingSpace: trailingSpace)]
        return self
    }
    public func user(_ value: User, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value("<@\(value.id)>", trailingSpace: trailingSpace)]
        return self
    }
    public func channel(_ value: Channel, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value("<#\(value.id)>", trailingSpace: trailingSpace)]
        return self
    }
    public func url(_ value: NSURL, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value(value.absoluteString, trailingSpace: trailingSpace)]
        return self
    }
    public func command(_ value: Command, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value(value.command, trailingSpace: trailingSpace)]
        return self
    }
    public func emoji(_ value: SlackEmoji, trailingSpace: Bool = true) -> SlackMessage {
        self.messageSegments += [self.value(value.emojiSymbol, trailingSpace: trailingSpace)]
        return self
    }
    public func newLine() -> SlackMessage {
        self.messageSegments += ["\n"]
        return self
    }
    
    public func apiMethod() -> ChatPostMessage {
        return ChatPostMessage(
            target: self.target,
            text: self.messageSegments.joined(separator: ""),
            options: self.options,
            customParameters: nil,
            attachments: nil
        )
    }
    
    //MARK: - Private
    private func value(_ string: String, trailingSpace: Bool) -> String {
        return "\(string)\(trailingSpace ? " " : "")"
    }
}

