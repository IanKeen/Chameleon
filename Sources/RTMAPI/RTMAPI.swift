//
//  RTMAPI.swift
//  Chameleon
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation
import Models
import Services
import Common
import Strand
import Vapor

/// Provides access to the Slack realtime messaging api
public final class RTMAPI {
    //MARK: - Typealiases
    public typealias SlackModelClosure = () -> (users: [User], channels: [Channel], groups: [Group], ims: [IM])
    
    //MARK: - Private Properties
    private let websocket: WebSocketService
    private var pingPongInterval: TimeInterval = 3.0
    private var pingPongTimer: Strand?
    
    //MARK: - Public Events
    /// Closure that is called when a websocket connection is made
    public var onConnected: (() -> Void)?
    
    /// Closure that is called when a websocket connection is closed with an error when applicable
    public var onDisconnected: ((error: ErrorProtocol?) -> Void)?
    
    /// Closure that is called when an error occurs
    public var onError: ((error: ErrorProtocol) -> Void)?
    
    /// Closure that is fired when a realtime messaging event occurs
    public var onEvent: ((event: RTMAPIEvent) -> Void)?
    
    //MARK: - Public Properties
    /// A closure that needs to be set before the rtmapi can correctly serialise and build responses.
    public var slackModels: SlackModelClosure?
    
    //MARK: - Lifecycle
    /**
     Create a new `RTMAPI` instance.
     
     - parameter websocket: A `WebSocketService` that will be used for the websocket connection
     - returns: New `RTMAPI` instance.
     */
    public init(websocket: WebSocketService) {
        self.websocket = websocket
        self.bindToSocketEvents()
    }
    
    //MARK: - Public
    /**
     Attempt a connection to a slack websocket url.
     
     - parameter url:              The url to attempt a connection to
     - parameter pingPongInterval: The number of seconds between sending each ping
     - throws: A `WebSocketServiceError` with failure details
     */
    public func connect(to url: String, pingPongInterval: TimeInterval) throws {
        self.pingPongInterval = pingPongInterval
        try self.websocket.connect(to: url)
    }
    
    /**
     Disconnect the websocket.
     */
    public func disconnect() {
        self.disconnect(error: nil)
    }
    private func disconnect(error: ErrorProtocol? = nil) {
        self.websocket.disconnect()
        self.onDisconnected?(error: error)
    }
    
    //TODO: sending messages via RTM
    //https://api.slack.com/rtm
    //remember to handle rate limiting once this is implemented
    //https://api.slack.com/docs/rate-limits
    
}

//MARK: - Ping Pong
extension RTMAPI {
    private func startPingPong() {
        self.stopPingPong()
        
        let ping = {
            sleep(UInt32(self.pingPongInterval))
            self.sendPingPong()
            self.startPingPong()
        }
        do { self.pingPongTimer = try Strand(closure: ping) }
        catch let error { self.onError?(error: error) }
    }
    private func stopPingPong() {
        guard let pingPongTimer = self.pingPongTimer else { return }
        _ = try? pingPongTimer.cancel()
        self.pingPongTimer = nil
    }
    private func sendPingPong() {
        //TODO: Date/Timestamp seem bugged right now - they aren't needed so I'll drop until it's finalilsed
        //
        //`timestamp` will come back in the response
        //could potentially be used later for checking 
        //latency as suggested in the docs
        
        let packet: [String: JSON] = [
            "id": JSON.number(.integer(Int.random(min: 1, max: 999999))),
            "type": JSON.string("ping")/*,
            "timestamp": JSON.number(.integer(Int(Date().timeIntervalSince1970)))*/
        ]
        
        do {
            let data = try JSON.serialize(JSON.object(packet))
            self.websocket.send(try data.string())
            
        } catch let error {
            self.onError?(error: error)
        }
    }
}

//MARK: - Socket
extension RTMAPI {
    private func bindToSocketEvents() {
        self.websocket.onConnect = { [weak self] in self?.websocketOnConnect() }
        self.websocket.onDisconnect = { [weak self] in self?.websocketOnDisconnect(error: $0) }
        self.websocket.onText = { [weak self] in self?.websocketOn(text: $0) }
        self.websocket.onData = { [weak self] in self?.websocketOn(data: $0) }
        self.websocket.onError = { [weak self] in self?.websocketOn(error: $0) }
    }
    
    private func websocketOnConnect() {
        self.onConnected?()
    }
    private func websocketOnDisconnect(error: ErrorProtocol?) {
        self.stopPingPong()
        self.onDisconnected?(error: error)
    }
    private func websocketOn(text: String) {
        do {
            let data = Array(text.utf8)
            let json = try JSON.parse(data)
            
            let eventBuilder = try RTMAPIEvent.makeEventBuilder(withJson: json)
            let event = try tryMake(
                eventBuilder,
                try eventBuilder.make(withJson: json, builderFactory: self.makeBuilder)
            )
            //let event = try eventBuilder.make(withJson: json, builderFactory: self.makeBuilder)
            
            if case .hello = event { self.startPingPong() }
            
            self.onEvent?(event: event)
            
        } catch let error {
            self.onError?(error: error)
        }
    }
    private func websocketOn(data: Bytes) {
        print("DATA: \(data)") //TODO: unused at this point
    }
    private func websocketOn(error: ErrorProtocol) {
        self.onError?(error: error)
        self.disconnect(error: error)
    }
}

//MARK: - Helpers
extension RTMAPI {
    private func makeBuilder(withJson json: JSON) -> SlackModelBuilder {
        guard let slackModels = self.slackModels else { fatalError("Please set `slackModels`") }
        
        let models = slackModels()
        return SlackModelBuilder(
            json: json,
            users: models.users,
            channels: models.channels,
            groups: models.groups,
            ims: models.ims
        )
    }
}

//MARK: - Errors
extension RTMAPI {
    /// Describes a range of errors that can occur when attempting to use the the realtime messaging api
    public enum Error: ErrorProtocol, CustomStringConvertible {
        /// The response was invalid or the data was unexpected
        case invalidResponse(json: JSON)
        
        public var description: String {
            switch self {
            case .invalidResponse(let json):
                return "The response was invalid:\n\(json.jsonValueDescription)"
            }
        }
    }
}
