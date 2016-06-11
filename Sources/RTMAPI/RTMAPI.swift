//
//  RTMAPI.swift
//  Slack
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation
import Models
import Services
import Common
import Strand
import Jay

public enum RTMAPIError: ErrorProtocol {
    case InvalidResponse(String)
    case UnknownError(String?)
}

public final class RTMAPI {
    //MARK: - Typealiases
    public typealias SlackModelClosure = () -> (users: [User], channels: [Channel], groups: [Group], ims: [IM])
    
    //MARK: - Private Properties
    private let websocket: WebSocketProtocol
    private var pingPongInterval: NSTimeInterval = 3.0
    private var pingPongTimer: Strand?
    
    //MARK: - Public Events
    public var onConnected: (() -> Void)?
    public var onDisconnected: ((error: ErrorProtocol?) -> Void)?
    public var onError: ((error: ErrorProtocol) -> Void)?
    public var onEvent: ((event: RTMAPIEvent) -> Void)?
    
    //MARK: - Public Properties
    public var slackModels: SlackModelClosure?
    
    //MARK: - Lifecycle
    public init(websocket: WebSocketProtocol) {
        self.websocket = websocket
        self.bindToSocketEvents()
    }
    
    //MARK: - Public
    public func connect(url: String, pingPongInterval: NSTimeInterval) throws {
        self.pingPongInterval = pingPongInterval
        try self.websocket.connect(url: url)
    }
    public func disconnect(error: ErrorProtocol? = nil) {
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
        //`timestamp` will come back in the response
        //could potentially be used later for checking 
        //latency as suggested in the docs
        
        let packet: [String: Any] = [
            "id": Int.random(min: 1, max: 999999),
            "type": "ping",
            "timestamp": NSDate().timeIntervalSince1970
        ]
        
        do {
            let data = try Jay().dataFromJson(packet)
            self.websocket.send(data: try data.string())
            
        } catch let error { self.onError?(error: error) }
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
            let json = try Jay().typesafeJsonFromData(Array(text.utf8))
            
            let eventBuilder = try RTMAPIEvent.builder(json: json)
            let event = try eventBuilder.make(json: json, builderFactory: self.builder)
            
            if case .hello = event { self.startPingPong() }
            
            self.onEvent?(event: event)
            
        } catch let error {
            self.onError?(error: error)
        }
    }
    private func websocketOn(data: NSData) {
        print("DATA: \(data)") //TODO: unused at this point
    }
    private func websocketOn(error: ErrorProtocol) {
        self.onError?(error: error)
        self.disconnect(error: error)
    }
}

//MARK: - Helpers
extension RTMAPI {
    private func builder(data: JSON) -> SlackModelBuilder {
        guard let slackModels = self.slackModels else { fatalError("Please set `slackModels`") }
        
        let models = slackModels()
        return SlackModelBuilder(
            data: data,
            users: models.users,
            channels: models.channels,
            groups: models.groups,
            ims: models.ims
        )
    }
}
