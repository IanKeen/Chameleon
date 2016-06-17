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
import Environment

extension SlackBotConfig {
    /// Supported Variables
    public enum Variables {
        /// URL for the Storage layer to use
        public static let StorageURL = "STORAGE_URL"
        
        /// Token to use for the bot
        public static let Token = "TOKEN"
        
        /// How many times to retry connecting before giving up
        public static let ReconnectionAttempts = "RECONNECTION_ATTEMPTS"
        
        /// How often to send a PING to slack once conencted to keep the connection alive
        public static let PingPongInterval = "PING_PONG_INTERVAL"
        
        /// All available environment variables
        public static var allVariables: [String] {
            return [Variables.StorageURL, Variables.Token, Variables.ReconnectionAttempts, Variables.PingPongInterval]
        }
    }
}

extension SlackBotConfig {
    /// Describes a range of errors that can occur when build configuration data
    public enum Error: ErrorProtocol {
        /// A required parameter was not provided
        case missingRequiredParameter(parameter: String)
        
        /// An invalid parameter was provided
        case invalidParameter(parameter: String)
        
        /// An unsupported parameter was provided
        case unsupportedParameter(parameter: String)
    }
}

/// Defines the configuration options that can be used
public struct SlackBotConfig {
    //MARK: - Public Properties
    /// The token of the bot user
    public let token: String
    
    /// Options passed to the RTMStart `WebAPIMethod` when connecting
    public var startOptions: [RTMStart.Option] = []
    
    /// How many times to retry connecting before giving up
    public var reconnectionAttempts: Int = 10
    
    /// How often to send a PING to slack once conencted to keep the connection alive
    public var pingPongInterval: NSTimeInterval = 5.0
    
    /// Optional: The url that can be used by the `Storage` object
    public var storageUrl: String? = nil
    
    //MARK: - Lifecycle
    public init(token: String?, startOptions: [RTMStart.Option]?, reconnectionAttempts: Int?, pingPongInterval: NSTimeInterval?, storageUrl: String?) throws {
        guard let token = token else { throw Error.missingRequiredParameter(parameter: "token") }
        
        self.token = token
        self.startOptions = startOptions ?? self.startOptions
        self.reconnectionAttempts = reconnectionAttempts ?? self.reconnectionAttempts
        self.pingPongInterval = pingPongInterval ?? self.pingPongInterval
        self.storageUrl = storageUrl ?? self.storageUrl
    }
}

//MARK: - Command line parameters
extension SlackBotConfig {
    /**
     Creates a `SlackBotConfig` from a `NSProcessInfo`s command line arguments
     
     - parameter process: The `NSProcessInfo` containing the arguments
     - throws: A `SlackBotConfig.Error` with failure details
     - returns: A new `SlackBotConfig` instance
     */
    public static func makeConfig(from process: NSProcessInfo) throws -> SlackBotConfig {
        let supportedArguments = Variables.allVariables.map { "--\($0.snakeToLowerCamel)=" }
        let arguments = try process.arguments.dropFirst().flatMap { argument -> (key: String, value: String) in
            let pair = argument.components(separatedBy: "=")
            guard
                let key = pair[safe: 0]?.components(separatedBy: "--").last,
                let value = pair[safe: 1]
                else { throw Error.invalidParameter(parameter: argument) }
            
            guard supportedArguments.contains("--\(key)=") else { throw Error.unsupportedParameter(parameter: argument) }
            
            return (key: key.lowercased(), value: value)
        }
        
        var dict = [String: String]()
        arguments.forEach { dict[$0.key] = $0.value }
        
        return try SlackBotConfig(
            token: dict[Variables.Token.lowercased()],
            startOptions: nil,
            reconnectionAttempts: Int(dict[Variables.ReconnectionAttempts.lowercased()] ?? ""),
            pingPongInterval: NSTimeInterval(dict[Variables.PingPongInterval.lowercased()] ?? ""),
            storageUrl: dict[Variables.StorageURL.lowercased()]
        )
    }
}

//MARK: - Environment Variables
extension SlackBotConfig {
    /**
     Creates a `SlackBotConfig` from a `Environment` variables
     
     - parameter environment: The `Environment` object containing the variables
     - throws: A `SlackBotConfig.Error` with failure details
     - returns: A new `SlackBotConfig` instance
     */
    public static func makeConfig(from environment: Environment) throws -> SlackBotConfig {
        return try SlackBotConfig(
            token: environment.getVar(Variables.Token),
            startOptions: nil,
            reconnectionAttempts: Int(environment.getVar(Variables.ReconnectionAttempts) ?? ""),
            pingPongInterval: NSTimeInterval(environment.getVar(Variables.PingPongInterval) ?? ""),
            storageUrl: environment.getVar(Variables.StorageURL)
        )
    }
}
