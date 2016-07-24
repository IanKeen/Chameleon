//
//  ChatPostMessage.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Services
import Common

/// Handler for the `chat.postMessage` endpoint
public struct ChatPostMessage: WebAPIMethod {
    public typealias SuccessParameters = (Void)
    
    //MARK: - Private Properties
    private let target: Target
    private let text: String
    private let options: [Option]
    private let customParameters: [String: String]?
    private let attachments: [Message.Attachment]?
    
    //MARK: - Lifecycle
    /**
     Creates a new `ChatPostMessage` instance
     
     - parameter target:           The `Target` to send the message to
     - parameter text:             The text to send
     - parameter options:          `ChatPostMessage.Option`s to use
     - parameter customParameters: Custom parameters to send
     - parameter attachments:      Attachments to this message
     
     - returns: A new instance
     */
    public init(target: Target, text: String, options: [Option] = [], customParameters: [String: String]? = nil, attachments: [Message.Attachment]? = nil) {
        self.target = target
        self.text = text
        self.options = options
        self.customParameters = customParameters
        self.attachments = attachments
    }
    
    //MARK: - Public
    public var networkRequest: HTTPRequest {
        let encodedText = self.text
        
        var params = [String: String]()
        
        params = params + [
            "channel": self.target.id,
            "text": encodedText
        ]
        
        for (key, value) in options.toParameters() {
            params[key] = value
        }
        
        for (key, value) in self.customParameters ?? [:] {
            params[key] = value
        }
        
        if let attachments = self.attachments.map({ $0.makeJSON() }) {
            do {
                let string = try JSON.serialize(attachments).string()
                params["attachments"] = string
                
            } catch let error {
                fatalError("\(error)")
            }
        }
        
        return HTTPRequest(
            method: .get,
            url: WebAPIURL("chat.postMessage"),
            parameters: params
        )
    }
    public func handle(headers: Headers, json: JSON, slackModels: SlackModels) throws -> SuccessParameters { }
}
