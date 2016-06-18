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

public class SlackBot {
    //MARK: - Private Properties
    private let config: SlackBotConfig
    private let apis: [SlackAPI]
    private var state: State = .Disconnected(force: false, error: nil) {
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
    public init(config: SlackBotConfig, storage: Storage, webAPI: WebAPI, rtmAPI: RTMAPI, apis: [SlackAPI]) {
        self.config = config
        self.storage = storage
        self.webAPI = webAPI
        self.rtmAPI = rtmAPI
        self.apis = apis
        
        self.webAPI.slackModels = self.slackModels()
        self.rtmAPI.slackModels = self.slackModels()
        
        self.bindToRTM()
    }
    
    //MARK: - Public Functions
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
    public func stop(force: Bool = false) {
        if (force) { self.state = .Disconnected(force: true, error: nil) }
        self.rtmAPI.disconnect()
    }
}

//MARK: - State
extension SlackBot {
    private enum State {
        case Disconnected(force: Bool, error: ErrorProtocol?)
        case Connecting(attempt: Int)
        case Connected(state: ConnectedState)
        
        var ready: Bool {
            switch self {
            case .Connected(let state):
                return state.contains(.Hello) && state.contains(.Data)
                
            default:
                return false
            }
        }
        
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
        case .Disconnected:
            return
            
        case .Connected:
            self.state = .Disconnected(force: false, error: nil)
            
        case .Connecting(let attempt):
            if (attempt >= self.config.reconnectionAttempts) {
                self.notifyDisconnected(error: error)
                self.state = .Disconnected(force: true, error: error)
                return
            }
        }
        
        self.start()
    }
}

//MARK: - API Propagation
extension SlackBot {
    private func notifyConnected(botUser: BotUser, team: Team, users: [User], channels: [Channel], groups: [Group], ims: [IM]) {
        self.apis.forEach { api in
            api.connected(
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
        self.apis.forEach { $0.disconnected(slackBot: self, error: error) }
    }
    private func notify(event: RTMAPIEvent) {
        guard self.state.ready else { return }
        self.apis.forEach { $0.event(slackBot: self, event: event, webApi: self.webAPI) }
    }
    func notify(error: ErrorProtocol) {
        guard self.state.ready else { return }
        self.apis.forEach { $0.error(slackBot: self, error: error) }
    }
    
    //Depending on the complexity of the `SlackBotAPI` api
    //I may adopt a similar pattern to the RTMEvent "builders"
    //so this doesn't become a massive switch
    private func notifyBotAPIs(event: RTMAPIEvent) {
        guard self.state.ready else { return }
        
        self.apis.forEach { api in
            if let api = api as? SlackBotAPI {
                switch event {
                case .message(let message, let previous):
                    api.message(
                        slackBot: self,
                        message: message.toAdaptor(slackModels: self.slackModels()),
                        previous: previous?.toAdaptor(slackModels: self.slackModels())
                    )
                    
                default: break
                }
            }
        }
    }
}

//MARK: - RTM
extension SlackBot {
    private func bindToRTM() {
        self.rtmAPI.onConnected = { /* */ }
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
            self.notifyBotAPIs(event: event)
        }
    }
}

//MARK: - Bot Event Handler
extension SlackBot {
    private func handle(event: RTMAPIEvent) {
        switch event {
        case .hello:
            self.state = self.state.connectedWith(state: .Hello)
            
        case .user_change(let user):
            if let index = self.users.index(of: user) {
                self.users.remove(at: index)
            }
            self.users.append(user)
            
        default: break
        }
    }
}

//MARK: - Model Helpers
extension SlackBot {
    typealias SlackModelClosure = WebAPI.SlackModelClosure
    
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
