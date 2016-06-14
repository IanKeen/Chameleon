//
//  EmojiList.swift
//  Slack
//
//  Created by Ian Keen on 6/06/2016.
//
//

import Models
import Services
import Jay

public struct EmojiList: WebAPIMethod {
    public typealias SuccessParameters = ([CustomEmoji])
    
    public init() { }
    
    public var networkRequest: HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: WebAPIURL("emoji.list")
        )
    }
    public func handleResponse(json: JSON, slackModels: SlackModels) throws -> SuccessParameters {
        guard var emoji = json["emoji"]?.dictionary else { return [] }
        
        return emoji.flatMap { key, value -> CustomEmoji? in
            guard
                let alias = value.string?.components(separatedBy: "alias:").last
                else { return nil }
            
            let imageUrl = emoji[alias]?.string ?? value.string ?? ""
            return CustomEmoji(name: key, imageUrl: imageUrl)
        }
    }
}