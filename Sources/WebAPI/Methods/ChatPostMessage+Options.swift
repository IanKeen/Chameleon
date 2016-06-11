//
//  ChatPostMessage+Options.swift
//  Slack
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

extension ChatPostMessage {
    public enum ParseMode: String {
        case None = "none"
        case Full = "full"
    }
    public enum Option {
        case Parse(ParseMode)
        case LinkNames(Bool)
        case UnfurlLinks(Bool)
        case UnfurlMedia(Bool)
        case Username(String)
        case AsUser(Bool)
        case IconURL(String)
        case IconEmoji(String)
        
        var key: String {
            switch self {
            case .Parse: return "parse"
            case .LinkNames: return "link_names"
            case .UnfurlLinks: return "unfurl_links"
            case .UnfurlMedia: return "unfurl_media"
            case .Username: return "username"
            case .AsUser: return "as_user"
            case .IconURL: return "icon_url"
            case .IconEmoji: return "icon_emoji"
            }
        }
        var value: String {
            switch self {
            case .Parse(let value): return value.rawValue
            case .LinkNames(let value): return String(value)
            case .UnfurlLinks(let value): return String(value)
            case .UnfurlMedia(let value): return String(value)
            case .Username(let value): return value
            case .AsUser(let value): return String(value)
            case .IconURL(let value): return value
            case .IconEmoji(let value): return value
            }
        }
    }
}

extension Sequence where Iterator.Element == ChatPostMessage.Option {
    func optionsData() -> [String: String] {
        var result = [String: String]()
        self.forEach { option in
            result[option.key] = option.value
        }
        return result
    }
}
