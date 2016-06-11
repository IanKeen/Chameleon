//
//  WebAPI.swift
//  Slack
//
//  Created by Ian Keen on 19/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation
import Models
import Services
import Common
import Jay

public func WebAPIURL(_ pathSegments: String...) -> NSURL? {
    let urlString = pathSegments.reduce("https://slack.com/api") { "\($0)/\($1)" }
    return NSURL(string: urlString)
}

public enum WebAPIError: ErrorProtocol {
    case Error(code: String)
}

public final class WebAPI {
    //MARK: - Typealiases
    public typealias SlackModelClosure = () -> (users: [User], channels: [Channel], groups: [Group], ims: [IM])
    
    //MARK: - Private
    private let network: NetworkProtocol
    private let token: String
    
    //MARK: - Public
    public var slackModels: SlackModelClosure?
    
    //MARK: - Lifecycle
    public init(token: String, network: NetworkProtocol) {
        self.token = token
        self.network = network
    }
    
    //MARK: - Public Functions
    public func execute<Method: WebAPIMethod>(method: Method) throws -> Method.SuccessParameters {
        guard let slackModels = self.slackModels else { fatalError("Please set `slackModels`") }
        
        let request = self.requestForMethod(method: method)
        let json = try self.network.makeRequest(request: request)
        
        try self.checkForError(json)
        
        return try method.handleResponse(json: json, slackModels: slackModels())
    }
    
    //MARK: - Private Helpers
    private func requestForMethod<Method: WebAPIMethod>(method: Method) -> NetworkRequest {
        guard method.requiresAuthentication else { return method.networkRequest }
        
        return NetworkRequest(
            method: method.networkRequest.method,
            url: method.networkRequest.url,
            parameters: method.networkRequest.parameters + ["token": self.token],
            headers: method.networkRequest.headers,
            jsonBody: method.networkRequest.jsonBody
        )
    }
    private func checkForError(_ json: JSON) throws {
        guard let ok = json["ok"]?.boolean where !ok else { return }
        
        let error = json["error"]?.string ?? "unknown_error"
        throw WebAPIError.Error(code: error)
    }
}
