//
//  ChatPostMessage.swift
//  Slack
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Services
import Common
import Jay

public struct ChatPostMessage: WebAPIMethod {
    public let target: Target
    public let text: String
    public let options: [Option]
    public let customParameters: [String: String]?
    public let attachments: [Message.Attachment]?
    
    public typealias SuccessParameters = (Void)
    
    public init(target: Target, text: String, options: [Option], customParameters: [String: String]?, attachments: [Message.Attachment]?) {
        self.target = target
        self.text = text
        self.options = options
        self.customParameters = customParameters
        self.attachments = attachments
    }
    
    public var networkRequest: HTTPRequest {
        let encodedText = self.text
        
        let requiredParams = [
            "channel": self.target.id,
            "text": encodedText
        ]
        let params = requiredParams + options.optionsData() + self.customParameters
        
        return HTTPRequest(
            method: .get,
            url: WebAPIURL("chat.postMessage"),
            parameters: params
        )
    }
    public func handleResponse(json: JSON, slackModels: SlackModels) throws -> SuccessParameters {
        return
    }
}