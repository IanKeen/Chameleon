//
//  SlackModelBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//


/**
 *  Builds Slack models from `[String: Any]` and completes object graphs from ids
 *
 *  Nested values can be looked up using keypaths such as "profile.bot_id"
 *
 *  Array lookups such as "profile.images[1]" are not currently supported
 *  (However they are not currently required for the Slack models)
 */
public struct SlackModelBuilder {
    internal let json: [String: Any]
    internal let users: [User]
    internal let channels: [Channel]
    internal let groups: [Group]
    internal let ims: [IM]
    
    /**
     Creates a new instance from the provided `[String: Any]` using the supplied models to complete the objects graph via ids
     
     - parameter json:     The `[String: Any]` used to build models
     - parameter users:    A sequence of `User`s used to find and populate any users in the graph via their id
     - parameter channels: A sequence of `Channel`s used to find and populate any channels in the graph via their id
     - parameter groups:   A sequence of `Group`s used to find and populate any groups in the graph via their id
     - parameter ims:      A sequence of `IM`s used to find and populate any ims in the graph via their id
     - returns: A new `SlackModelBuilder` instance
     */
    public init(json: [String: Any], users: [User], channels: [Channel], groups: [Group], ims: [IM]) {
        self.json = json
        self.users = users
        self.channels = channels
        self.groups = groups
        self.ims = ims
    }
}

//MARK: - Helpers
internal extension SlackModelBuilder {
    //Not super stoked on this... but it does the job for now
    internal func identifiables() -> [SlackModelTypeIdentifiable] {
        //combatting `Expression was too complex...`
        var items = [SlackModelTypeIdentifiable]()
        items.append(contentsOf: self.users.flatMap({ $0 as SlackModelTypeIdentifiable }))
        items.append(contentsOf: self.users.botUsers().flatMap({ $0 as SlackModelTypeIdentifiable }))
        items.append(contentsOf: self.channels.flatMap({ $0 as SlackModelTypeIdentifiable }))
        items.append(contentsOf: self.groups.flatMap({ $0 as SlackModelTypeIdentifiable }))
        items.append(contentsOf: self.ims.flatMap({ $0 as SlackModelTypeIdentifiable }))
        return items
    }
    internal func targets() -> [Target] {
        return self.identifiables().flatMap { $0 as? Target }
    }
}
