//
//  WebAPIMethod.swift
// Chameleon
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Services
import Jay

/// Represents the core slack types
public typealias SlackModels = (users: [User], channels: [Channel], groups: [Group], ims: [IM])

/// An abstraction representing an object that can execute and handle the response of a webapi method
public protocol WebAPIMethod {
    /// Represents the value(s) that will be returned by the `WebAPIMethod`
    associatedtype SuccessParameters
    
    /// The `HTTPRequest` used to execute the webapi method
    var networkRequest: HTTPRequest { get }
    
    /// A `Bool` to let `WebAPI` know if the `HTTPRequest` needs authentication (default: `true`)
    var requiresAuthentication: Bool { get }
    
    /**
     Handle the `JSON` response from an executed `WebAPIMethod`
     
     - parameter json:        The `JSON` result
     - parameter slackModels: The `SlackModels` that can be used to create a `SlackModelBuilder` for constructing a type-safe response
     - throws: Any `ErrorProtocol` that might result from the handling of the `JSON` response
     - returns: The result of handling the `JSON`
     */
    func handle(json: JSON, slackModels: SlackModels) throws -> SuccessParameters
}

extension WebAPIMethod {
    public var requiresAuthentication: Bool { return true }
}

/**
 Creates a new `SlackModelBuilder` instance using the provided `JSON` 
 and, optionally, existing models
 
 - parameter json:     `JSON` data to use when building models
 - parameter users:    optional: A `User` array
 - parameter channels: optional: A `Channel` array
 - parameter groups:   optional: A `Group` array
 - parameter ims:      optional: An `IM` array
 
 - returns: A new `SlackModelBuilder` instance
 */
public func makeSlackModelBuilder(
    json: JSON,
    users: [User] = [],
    channels: [Channel] = [],
    groups: [Group] = [],
    ims: [IM] = []) -> SlackModelBuilder {
    return SlackModelBuilder(
        json: json,
        users: users,
        channels: channels,
        groups: groups,
        ims: ims
    )
}
