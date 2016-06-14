//
//  WebAPIMethod.swift
//  Slack
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Models
import Services
import Jay

public enum WebAPIMethodError: ErrorProtocol {
    case UnexpectedResponse
}

public typealias SlackModels = (users: [User], channels: [Channel], groups: [Group], ims: [IM])

public protocol WebAPIMethod {
    associatedtype SuccessParameters
    
    var networkRequest: HTTPRequest { get }
    var requiresAuthentication: Bool { get }
    
    func handleResponse(json: JSON, slackModels: SlackModels) throws -> SuccessParameters
}

extension WebAPIMethod {
    public var requiresAuthentication: Bool { return true }
}
