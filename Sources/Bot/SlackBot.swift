//
//  SlackBot.swift
//  Chameleon
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import WebAPI
import RTMAPI
import Common

/// An extensible Slack bot user than can provide custom functionality
public class SlackBot {
    //MARK: - Private Properties
    private let config: SlackBotConfig
    private let services: [SlackService]
    private var state: State = .Disconnected(reconnect: true, error: nil) {
        didSet {
            print("STATE: \(self.state)")
            
            if (self.state.ready) {
                guard
                    let botUser = self.botUser,
                    let team = self.team
                    else { fatalError("Something went wrong, we should have botUser and team data at this point!") }
                
                self.notifyConnected(
                    botUser: botUser,
                    team: team,
                    users: self.users,
                    channels: self.channels,
                    groups:  self.groups,
                    ims: self.ims
                )
            }
        }
    }
    
    //MARK: - Properties
    let webAPI: WebAPI
    let rtmAPI: RTMAPI
    private(set) var botUser: BotUser?
    private(set) var team: Team?
    private(set) var users: [User] = []
    private(set) var channels: [Channel] = []
    private(set) var groups: [Group] = []
    private(set) var ims: [IM] = []
    //private(set) var mpims: [MPIM] = []
    
    //MARK: - Public Properties
    public private(set) var storage: Storage
    
    //MARK: - Lifecycle
    /**
     Creates a new `SlackBot` instance
     
     - parameter config:   The `SlackBotConfig` with the configuration for this instance
     - parameter storage:  The `Storage` implementation used for simple key/value storage
     - parameter webAPI:   The `WebAPI` used for interaction with the Slack WebAPI
     - parameter rtmAPI:   The `RTMAPI` used for interaction with the Slack Real-time messaging api
     - parameter services: A sequence of `SlackService`s that provide this bots functionality
     
     - returns: A new `SlackBot` instance
     */
    public init(config: SlackBotConfig, storage: Storage, webAPI: WebAPI, rtmAPI: RTMAPI, services: [SlackService]) {
        self.config = config
        self.storage = storage
        self.webAPI = webAPI
        self.rtmAPI = rtmAPI
        self.services = services
        
        self.webAPI.slackModels = self.slackModels()
        self.rtmAPI.slackModels = self.slackModels()
        
        self.bindToRTM()
    }
    
    //MARK: - Public Functions
    /// Start the bot
    public func start() {
        switch self.state {
        case .Connected: return
        case .Disconnected: self.state = .Connecting(attempt: 0)
        case .Connecting(let attempt): self.state = .Connecting(attempt: attempt + 1)
        }
        
        do {
            let rtmStart = RTMStart(options: self.config.startOptions) { [weak self] serializedData in
                guard let `self` = self else { return }
                
                do {
                    let (botUser, team, users, channels, groups, ims) = try serializedData()
                    
                    self.botUser = botUser
                    self.team = team
                    self.users = users
                    self.channels = channels
                    self.groups = groups
                    self.ims = ims
                    
                    self.state = self.state.connectedWith(state: .Data)
                    
                } catch let error {
                    self.handleConnectionError(error)
                }
            }
            let RTMURL = try self.webAPI.execute(method: rtmStart)
            try self.rtmAPI.connect(url: RTMURL, pingPongInterval: self.config.pingPongInterval)

        } catch let error {
            self.handleConnectionError(error)
        }
    }
    
    /**
     Stops the bot
     
     - parameter reconnect: When true, the bot will attempt to reconnected after stopping
     */
    public func stop(reconnect: Bool = true) {
        if (!reconnect) { self.state = .Disconnected(reconnect: false, error: nil) }
        self.rtmAPI.disconnect()
    }
}

//MARK: - State
extension SlackBot {
    /// Defines the states the bot will move through during connection
    private enum State {
        /**
         *  The bot is disconnected
         *
         *  @param Bool           Whether a reconnection should be attempted.
         *                        Reconnection attempts are caused by a call to `stop(reconnect: true)`
         *                        or when we haven't exceeded the maximum number of retry attempts yet
         *
         *  @param ErrorProtocol? Exists when the disconnection was the result of an error
         */
        case Disconnected(reconnect: Bool, error: ErrorProtocol?)
        
        /**
         *  The bot is attempting to connect
         *
         *  @param Int The attempt number
         */
        case Connecting(attempt: Int)
        
        /**
         *  The bot is connected.
         *  NOTE: There are two things that need to happen for the bot to be considered 'ready'
         *
         *  1. We need to receive the `.hello` event from the `RTMAPI`
         *  2. The `RTMStart` WebAPI method has to deserialise the Slack teams models
         *
         *  Because `RTMStart` is performed asynchronously the order of 1 & 2 are not guaranteed
         *  so we use a nested `OptionSet` to keep track of each event.
         *
         *  @param ConnectedState The nested `OptionSet` with the current `ConnectedState`
         */
        case Connected(state: ConnectedState)
        
        /**
            Defines whether all requirements for the bot to be considered ready have completed
         
            - seealso: For more information on the requirements see: `State.Connected(state:)`
         */
        var ready: Bool {
            switch self {
            case .Connected(let state):
                return state.contains(.Hello) && state.contains(.Data)
                
            default:
                return false
            }
        }
        
        /**
         Updates the nested `ConnectedState` for the `State.Connected` parent state
         
         - parameter new: The `ConnectedState` that has been completed
         - returns: An updated `State` value
         */
        func connectedWith(state new: ConnectedState) -> State {
            var current = self
            switch self {
            case .Connected(let state):
                current = .Connected(state: state.union(new))
            default:
                current = .Connected(state: new)
            }
            return current
        }
    }
    private struct ConnectedState: OptionSet {
        let rawValue: Int
        init(rawValue: Int) { self.rawValue = rawValue }
        static let Hello = ConnectedState(rawValue: 1)
        static let Data = ConnectedState(rawValue: 2)
    }
}

//MARK: - Errors
extension SlackBot {
    //
    //TODO: add a back-off for retries
    //
    private func handleConnectionError(_ error: ErrorProtocol?) {
        switch self.state {
        case .Disconnected(let reconnect, _):
            if (!reconnect) { return }
            
        case .Connected:
            self.state = .Disconnected(reconnect: true, error: nil)
            
        case .Connecting(let attempt):
            if (attempt >= self.config.reconnectionAttempts) {
                self.notifyDisconnected(error: error)
                self.state = .Disconnected(reconnect: false, error: error)
                return
            }
        }
        
        self.start()
    }
}

//MARK: - Service Propagation
extension SlackBot {
    private func notifyConnected(botUser: BotUser, team: Team, users: [User], channels: [Channel], groups: [Group], ims: [IM]) {
        let services = self.services.flatMap { $0 as? SlackConnectionService }
        
        for service in services {
            service.connected(
                slackBot: self,
                botUser: botUser,
                team: team,
                users: users,
                channels: channels,
                groups: groups,
                ims: ims
            )
        }
    }
    private func notifyDisconnected(error: ErrorProtocol?) {
        let services = self.services.flatMap { $0 as? SlackDisconnectionService }
        
        for service in services {
            service.disconnected(slackBot: self, error: error)
        }
    }
    private func notify(event: RTMAPIEvent) {
        guard self.state.ready else { return }
        
        for service in self.services {
            if let service = service as? SlackRTMEventService {
                service.event(slackBot: self, event: event, webApi: self.webAPI)
            }
            
            //Depending on the number of specialized `SlackService`s
            //I may adopt a similar pattern to the RTMEvent "builders"
            //so this doesn't become a massive switch
            switch (service, event) {
            case (let service as SlackMessageService, .message(let message, let previous)):
                service.message(
                    slackBot: self,
                    message: message.toAdaptor(slackModels: self.slackModels()),
                    previous: previous?.toAdaptor(slackModels: self.slackModels())
                )
                
            default: break
            }
        }
    }
    func notify(error: ErrorProtocol) {
        guard self.state.ready else { return }
        
        let services = self.services.flatMap { $0 as? SlackErrorService }
        
        for service in services {
            service.error(slackBot: self, error: error)
        }
    }
}

//MARK: - RTM
extension SlackBot {
    private func bindToRTM() {
        self.rtmAPI.onConnected = { /* not used at this time as the 'real' connected event is linked to .hello and data */ }
        self.rtmAPI.onDisconnected = { [weak self] error in
            self?.handleConnectionError(error)
        }
        self.rtmAPI.onError = { [weak self] error in
            self?.notify(error: error)
        }
        self.rtmAPI.onEvent = { [weak self] event in
            guard let `self` = self else { return }
            
            self.handle(event: event)
            self.notify(event: event)
        }
    }
}

//MARK: - Bot Event Handler
extension SlackBot {
    // TODO: turn this into an actual `SlackService`
    
    /// Handles internal/bot specific `RTMAPIEvent`s
    private func handle(event: RTMAPIEvent) {
        switch event {
        case .hello:
            self.state = self.state.connectedWith(state: .Hello)
            
        case .user_change(let user):
            if let index = self.users.index(of: user) {
                self.users.remove(at: index)
            }
            self.users.append(user)
            
        case .channel_created(let channel):
            self.channels.append(channel)
            
        case .channel_rename(let channel, _):
            if let index = self.channels.index(of: channel) {
                self.channels.remove(at: index)
            }
            self.channels.append(channel)
            
        default: break
        }
    }
}

//MARK: - Model Helpers
extension SlackBot {
    typealias SlackModelClosure = WebAPI.SlackModelClosure
    
    /// Returns a closure that can be used to get an up-to-date set of Slack model data
    private func slackModels() -> SlackModelClosure {
        return {
            return (
                users: self.users,
                channels: self.channels,
                groups: self.groups,
                ims: self.ims
            )
        }
    }
}
