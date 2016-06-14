//
//  RTMStart.swift
//  Slack
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Services
import Jay
import Strand

public struct RTMStart: WebAPIMethod {
    public typealias RTMStartData = (botUser: BotUser, team: Team, users: [User], channels: [Channel], groups: [Group], ims: [IM])
    
    let authenticationParameters: [String: String]
    let dataReady: (serializedData: () throws -> RTMStartData) -> Void

    public typealias SuccessParameters = (String)
    
    public init(authenticationParameters: [String: String], dataReady: (serializedData: () throws -> RTMStartData) -> Void) {
        self.authenticationParameters = authenticationParameters
        self.dataReady = dataReady
    }
    
    public var networkRequest: HTTPRequest {
        let params = self.authenticationParameters
        
        return HTTPRequest(
            method: .get,
            url: WebAPIURL("rtm.start"),
            parameters: params
        )
    }
    public func handleResponse(json: JSON, slackModels: SlackModels) throws -> SuccessParameters {
        guard let socketUrl = json["url"]?.string else { throw WebAPIMethodError.UnexpectedResponse }
        
        _ = try Strand {
            guard
                let selfJson = json["self"],
                let teamJson = json["team"],
                let userJson = json["users"]?.array,
                let channelJson = json["channels"]?.array,
                let groupJson = json["groups"]?.array,
                let imJson = json["ims"]?.array
                else { return self.dataReady(serializedData: { throw WebAPIMethodError.UnexpectedResponse }) }
            
            do {
                print("Deserializing \(userJson.count) Users")
                let users = try userJson.map { try User.make(builder: self.modelBuilder(data: $0)) }
                
                print("Deserializing \(channelJson.count) Channels")
                let channels = try channelJson.map { try Channel.make(builder: self.modelBuilder(data: $0, users: users)) }
                
                print("Deserializing \(groupJson.count) Groups")
                let groups = try groupJson.map { try Group.make(builder: self.modelBuilder(data: $0, users: users)) }
                
                print("Deserializing \(imJson.count) IMs")
                let ims = try imJson.map { try IM.make(builder: self.modelBuilder(data: $0, users: users)) }
                
                print("Deserializing Bot User and Team")
                let botUser = try BotUser.make(builder: self.modelBuilder(data: selfJson))
                let team = try Team.make(builder: self.modelBuilder(data: teamJson))
                
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
    
    private func modelBuilder(
        data: JSON,
        users: [User] = [],
        channels: [Channel] = [],
        groups: [Group] = [],
        ims: [IM] = []) -> SlackModelBuilder {
        return SlackModelBuilder(
            data: data,
            users: users,
            channels: channels,
            groups: groups,
            ims: ims
        )
    }
}