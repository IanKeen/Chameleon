//
//  SlackBot+Config.swift
// Chameleon
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation
import Common
import WebAPI

public struct SlackBotConfig {
    public let token: String
    public var startOptions: [RTMStart.Option] = []
    public var reconnectionAttempts: Int = 10
    public var pingPongInterval: NSTimeInterval = 5.0
    
    public init(token: String, startOptions: [RTMStart.Option]?, reconnectionAttempts: Int?, pingPongInterval: NSTimeInterval?) {
        self.token = token
        if let startOptions = startOptions { self.startOptions = startOptions }
        if let reconnectionAttempts = reconnectionAttempts { self.reconnectionAttempts = reconnectionAttempts }
        if let pingPongInterval = pingPongInterval { self.pingPongInterval = pingPongInterval }
    }
}

//
//TOOD: this is horrible/half assed...
//      it was added last minute just to provide a simple was on injecting the token
//      dont judge me! I will built something more robust eventually
//

public enum SlackBotConfigError: ErrorProtocol {
    case MissingRequiredParameter(String)
    case InvalidArgument(String)
}

extension SlackBotConfig {
    public init(input: [String] = NSProcessInfo.processInfo().arguments) throws {
        var dict = [String: String]()
        
        //Attempt to filter out invalid parameters
        try input
            .filter { $0.characters.count > 4 && $0.hasPrefix("--") && $0.characters.contains("=") }
            .map { argument in
                let sanitizedArgument = argument.substring(from: argument.index(argument.startIndex, offsetBy: 2))
                let pair = sanitizedArgument.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true)
                guard let key = pair[safe: 0], let value = pair[safe: 1] else { throw SlackBotConfigError.InvalidArgument(argument) }
                return (key: key, value: value)
            }
            .forEach { key, value in
                dict[key] = value
            }
        
        guard let token = dict["token"] else { throw SlackBotConfigError.MissingRequiredParameter("token") }
        
        self = SlackBotConfig(
            token: token,
            startOptions: nil,
            reconnectionAttempts: Int(dict["reconnectionAttempts"] ?? ""),
            pingPongInterval: NSTimeInterval(dict["pingPongInterval"] ?? "")
        )
    }
}
