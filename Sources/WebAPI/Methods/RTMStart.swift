//
//  RTMStart.swift
//  Chameleon
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Services
import Strand

/// Handler for the `rtm.start` endpoint
public struct RTMStart: WebAPIMethod {
    public typealias RTMStartData = (botUser: BotUser, team: Team, users: [User], channels: [Channel], groups: [Group], ims: [IM])
    public typealias SuccessParameters = (String)
    
    //MARK: - Private Properties
    private let options: [Option]
    private let dataReady: (serializedData: () throws -> RTMStartData) -> Void
    
    //MARK: - Lifecycle
    /**
     Create a new `RTMStart` instance
     
     NOTE: The `RTMStart` method is performed on another thread. 
     
     When signing in all the data for users, channels, groups and IMs needs to be parsed to achieve a typed experience. 
     On larger teams this could cause the websocket link to timeout before this processing is done. 
     By moving this work to another thread we can continue connecting and then complete the start up once the work here is done.
     
     - parameter options:   `RTMStart.Option`s to use
     - parameter dataReady: The closure to call upon success; throws on failure
     
     - returns: A new instance
     */
    public init(options: [Option] = [], dataReady: (serializedData: () throws -> RTMStartData) -> Void) {
        self.options = options
        self.dataReady = dataReady
    }
    
    //MARK: - Public
    public var networkRequest: HTTPRequest {
        let params = self.options.toParameters()
        
        return HTTPRequest(
            method: .get,
            url: WebAPIURL("rtm.start"),
            parameters: params
        )
    }
    public func handle(headers: [String: String], json: [String: Any], slackModels: SlackModels) throws -> SuccessParameters {
        guard let socketUrl = json["url"] as? String else { throw WebAPIError.invalidResponse(json: json) }
        
        _ = try Strand {
            guard
                let selfJson = json["self"] as? [String: Any],
                let teamJson = json["team"] as? [String: Any],
                let userJson = json["users"] as? [[String: Any]],
                let channelJson = json["channels"] as? [[String: Any]],
                let groupJson = json["groups"] as? [[String: Any]],
                let imJson = json["ims"] as? [[String: Any]]
                else { return self.dataReady(serializedData: { throw WebAPIError.invalidResponse(json: json) }) }
            
            do {
                print("Deserializing \(userJson.count) Users")
                let users = try userJson.map { try User.makeModel(with: makeSlackModelBuilder(json: $0)) }
                
                print("Deserializing \(channelJson.count) Channels")
                let channels = try channelJson.map { try Channel.makeModel(with: makeSlackModelBuilder(json: $0, users: users)) }
                
                print("Deserializing \(groupJson.count) Groups")
                let groups = try groupJson.map { try Group.makeModel(with: makeSlackModelBuilder(json: $0, users: users)) }
                
                print("Deserializing \(imJson.count) IMs")
                let ims = try imJson.map { try IM.makeModel(with: makeSlackModelBuilder(json: $0, users: users)) }
                
                print("Deserializing Bot User and Team")
                let botUser = try BotUser.makeModel(with: makeSlackModelBuilder(json: selfJson))
                let team = try Team.makeModel(with: makeSlackModelBuilder(json: teamJson))
                
                self.dataReady(serializedData: { return
                    (botUser: botUser,
                    team: team,
                    users: users,
                    channels: channels,
                    groups: groups,
                    ims: ims)
                })
                
            } catch let error {
                return self.dataReady(serializedData: { throw error })
            }
        }
        return socketUrl
    }
}
