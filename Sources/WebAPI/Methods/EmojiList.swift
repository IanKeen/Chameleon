//
//  EmojiList.swift
//  Chameleon
//
//  Created by Ian Keen on 6/06/2016.
//
//

import Models
import Services
import Foundation

/// Handler for the `emoji.list` endpoint
public struct EmojiList: WebAPIMethod {
    public typealias SuccessParameters = ([CustomEmoji])
    
    //MARK: - Lifecycle
    /**
     Create a new `EmojiList` instance
     
     - returns: A new instance
     */
    public init() { }
    
    //MARK: - Public
    public var networkRequest: HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: WebAPIURL("emoji.list")
        )
    }
    public func handle(headers: Headers, json: JSON, slackModels: SlackModels) throws -> SuccessParameters {
        guard var emoji = json["emoji"]?.dictionary else { return [] }
        
        return emoji.flatMap { (key: String, value: JSON) -> CustomEmoji? in
            guard
                let string = value.string,
                let alias = string.components(separatedBy: "alias:").last
                else { return nil }
            
            let imageUrl = emoji[alias]?.string ?? value.string ?? ""
            return CustomEmoji(name: key, imageUrl: imageUrl)
        }
    }
}

//TODO:
//MARK: remove when dependencies are cleared up
import Vapor
private extension JSON {
    var string: String? { return (self as Polymorphic).string }
}
