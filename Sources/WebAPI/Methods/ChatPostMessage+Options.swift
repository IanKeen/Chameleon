//
//  ChatPostMessage+Options.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

extension ChatPostMessage {
    /// Defines how the message will be parsed
    public enum ParseMode: String {
        /// Slack will not perform _any_ processing of this message.
        case none
        
        /// Slack will treat the message as completely unformatted. Channel names and user names will be linkified.
        case full
    }
    
    /// Defines the options available when sending a message.
    public enum Option {
        /// Specify the `ParseMode` to use for this message.
        case parse(ParseMode)
        
        /// When `true` will linkify channel names and usernames. This behavior is always enabled in `ParseMode.full` mode.
        case linkNames(Bool)
        
        /// Specify whether or not to unfurl text based content.
        case unfurlLinks(Bool)
        
        /// Specify whether or not to unfurl media based content.
        case unfurlMedia(Bool)
        
        /// Set the bot's user name. Must be used in conjunction with `asUser(false)`, otherwise ignored.
        case username(String)
        
        /// When `true` posts the message as the authed user, instead of as a bot.
        case asUser(Bool)
        
        /// URL to an image to use as the icon for this message. Must be used in conjunction with `asUser(false)`, otherwise ignored.
        case iconURL(String)
        
        /// Emoji to use as the icon for this message. Overrides `iconURL`. Must be used in conjunction with `asUser(false)`, otherwise ignored.
        case iconEmoji(String)
    }
}

extension ChatPostMessage.Option: OptionRepresentable {
    var key: String {
        switch self {
        case .parse: return "parse"
        case .linkNames: return "link_names"
        case .unfurlLinks: return "unfurl_links"
        case .unfurlMedia: return "unfurl_media"
        case .username: return "username"
        case .asUser: return "as_user"
        case .iconURL: return "icon_url"
        case .iconEmoji: return "icon_emoji"
        }
    }
    var value: String {
        switch self {
        case .parse(let value): return value.rawValue
        case .linkNames(let value): return String(value)
        case .unfurlLinks(let value): return String(value)
        case .unfurlMedia(let value): return String(value)
        case .username(let value): return value
        case .asUser(let value): return String(value)
        case .iconURL(let value): return value
        case .iconEmoji(let value): return value
        }
    }
}
