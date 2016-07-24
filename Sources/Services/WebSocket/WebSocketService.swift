//
//  WebSocketService.swift
//  Chameleon
//
//  Created by Ian Keen on 10/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation

/// An abstraction representing an object capable of synchronous web sockets
public protocol WebSocketService: class {
    /// Closure that is called when a connection is opened
    var onConnect: (() -> Void)? { get set }
    
    /// Closure that is called when a connection is closed with an error when applicable
    var onDisconnect: ((ErrorProtocol?) -> Void)? { get set }
    
    /// Closure that is called when receiving text data
    var onText: ((String) -> Void)? { get set }
    
    /// Closure that is called when receiving byte data
    var onData: ((Bytes) -> Void)? { get set }
    
    /// Closure that is called when an error occurs
    var onError: ((ErrorProtocol) -> Void)? { get set }
    
    /**
     Attempt to open a connection to a specified url
     
     - parameter url: The url to connect to
     - throws: A `WebSocketServiceError` with failure details
     */
    func connect(to url: String) throws
    
    /**
     Disconnect a connection
     */
    func disconnect()
    
    /**
     Send `JSON` data
     
     - parameter json: `JSON` to send
     */
    func send(_ json: JSON)
    
    /**
     Send `NSData` data
     
     - parameter data: `NSData` to send
     */
    func send(_ data: Bytes)
    
    /**
     Send `String` data
     
     - parameter string: `String` to send
     */
    func send(_ string: String)
}

/// Describes a range of errors that can occur when attempting to use the service
public enum WebSocketServiceError: ErrorProtocol, CustomStringConvertible {
    /// The provided URL was invalid
    case invalidURL(url: String)
    
    /// Generic socket error
    case genericError(reason: String)
    
    /// Something went wrong with an dependency
    case internalError(error: ErrorProtocol)
    
    public var description: String {
        switch self {
        case .invalidURL(let url):
            return "The provided url was invalid: \(url)"
        case .internalError(let error):
            let nestedDescription = (error as? CustomStringConvertible)?.description ?? String(error)
            return "Internal Error: \(nestedDescription)"
        case .genericError(let reason):
            return "Generic Error: \(reason)"
        }
    }
}
