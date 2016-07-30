//
//  WebAPIMethod.swift
//  Chameleon
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Services

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
     Handle the `[String: Any]` response from an executed `WebAPIMethod`
     
     - parameter headers:     The `[String: String]` of the request
     - parameter json:        The `[String: Any]` result
     - parameter slackModels: The `SlackModels` that can be used to create a `SlackModelBuilder` for constructing a type-safe response
     - throws: Any `Error` that might result from the handling of the `[String: Any]` response
     - returns: The result of handling the `[String: Any]`
     */
    func handle(headers: [String: String], json: [String: Any], slackModels: SlackModels) throws -> SuccessParameters
}

public extension WebAPIMethod {
    public var requiresAuthentication: Bool { return true }
}

/**
 Creates a new `SlackModelBuilder` instance using the provided `[String: Any]`
 and, optionally, existing models
 
 - parameter json:     `[String: Any]` data to use when building models
 - parameter users:    optional: A `User` array
 - parameter channels: optional: A `Channel` array
 - parameter groups:   optional: A `Group` array
 - parameter ims:      optional: An `IM` array
 
 - returns: A new `SlackModelBuilder` instance
 */
public func makeSlackModelBuilder(
    json: [String: Any],
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
