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

public func WebAPIURL(_ pathSegments: String...) -> NSURL {
    let urlString = "https://slack.com/api/" + pathSegments.joined(separator: "/")
    guard let url = NSURL(string: urlString) else { fatalError("Invalid URL: \(urlString)") }
    return url
}

public enum WebAPIError: ErrorProtocol {
    case Error(code: String)
    case InvalidURL(url: String)
}

public final class WebAPI {
    //MARK: - Typealiases
    public typealias SlackModelClosure = () -> (users: [User], channels: [Channel], groups: [Group], ims: [IM])
    
    //MARK: - Private
    private let http: HTTPService
    private let token: String
    
    //MARK: - Public
    public var slackModels: SlackModelClosure?
    
    //MARK: - Lifecycle
    public init(token: String, http: HTTPService) {
        self.token = token
        self.http = http
    }
    
    //MARK: - Public Functions
    public func execute<Method: WebAPIMethod>(method: Method) throws -> Method.SuccessParameters {
        guard let slackModels = self.slackModels else { fatalError("Please set `slackModels`") }
        
        let request = self.requestForMethod(method: method)
        let json = try self.http.perform(request: request)
        
        try self.checkForError(json)
        
        return try method.handleResponse(json: json, slackModels: slackModels())
    }
    
    //MARK: - Private Helpers
    private func requestForMethod<Method: WebAPIMethod>(method: Method) -> HTTPRequest {
        guard method.requiresAuthentication else { return method.networkRequest }
        
        return HTTPRequest(
            method: method.networkRequest.method,
            url: method.networkRequest.url,
            parameters: method.networkRequest.parameters + ["token": self.token],
            headers: method.networkRequest.headers,
            body: method.networkRequest.body
        )
    }
    private func checkForError(_ json: JSON) throws {
        guard let ok = json["ok"]?.boolean where !ok else { return }
        
        let error = json["error"]?.string ?? "unknown_error"
        throw WebAPIError.Error(code: error)
    }
}
