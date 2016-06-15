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

/**
 Builds a complete url to a webapi endpoint
 
 NOTE: will `fatalError()` when it cannot builda valid `NSURL`
 
 - parameter pathSegments: `String` path segments
 - returns: A complete `NSURL`
 */
public func WebAPIURL(_ pathSegments: String...) -> NSURL {
    let urlString = "https://slack.com/api/" + pathSegments.joined(separator: "/")
    guard let url = NSURL(string: urlString) else { fatalError("Invalid URL: \(urlString)") }
    return url
}

/// Provides access to the Slack webapi
public final class WebAPI {
    //MARK: - Typealiases
    public typealias SlackModelClosure = () -> (users: [User], channels: [Channel], groups: [Group], ims: [IM])
    
    //MARK: - Private
    private let http: HTTPService
    private let token: String
    
    //MARK: - Public
    /// A closure that needs to be set before the webapi can correctly serialise and build responses.
    public var slackModels: SlackModelClosure?
    
    //MARK: - Lifecycle
    /**
     Create a new `WebAPI` instance.s
     
     - parameter token: The token to use in authenticated webapi requests
     - parameter http:  The `HTTPService` to use when making requests
     - returns: New `WebAPI` instance
     */
    public init(token: String, http: HTTPService) {
        self.token = token
        self.http = http
    }
    
    //MARK: - Public Functions
    /**
     Executes a webapi request using the provided `WebAPIMethod`.
    
     NOTE: Will crash if `.slackModels` has not been set
     
     - parameter method: A `WebAPIMethod` to execute
     - throws: Can throw `WebAPI.Error`, `HTTPServiceError` or a custom error from the provided `WebAPIMethod`
     - returns: The values specified in the `WebAPIMethod`
     */
    public func execute<Method: WebAPIMethod>(method: Method) throws -> Method.SuccessParameters {
        guard let slackModels = self.slackModels else { fatalError("Please set `slackModels`") }
        
        let request = self.request(for: method)
        let json = try self.http.perform(with: request)
        
        try self.checkForError(in: json)
        
        return try method.handle(json: json, slackModels: slackModels())
    }
    
    //MARK: - Private Helpers
    private func request<Method: WebAPIMethod>(for method: Method) -> HTTPRequest {
        guard method.requiresAuthentication else { return method.networkRequest }
        
        //Copy the method, inserting the token
        return HTTPRequest(
            method: method.networkRequest.method,
            url: method.networkRequest.url,
            parameters: method.networkRequest.parameters + ["token": self.token],
            headers: method.networkRequest.headers,
            body: method.networkRequest.body
        )
    }
    private func checkForError(in json: JSON) throws {
        guard let ok = json["ok"]?.boolean where !ok else { return }
        
        let error = json["error"]?.string ?? "unknown_error"
        throw Error.apiError(reason: error)
    }
}

extension WebAPI {
    /// Describes a range of errors that can occur when attempting to use the the webapi
    public enum Error: ErrorProtocol {
        /// Something went wrong during execution
        case apiError(reason: String)
        
        /// The response was invalid or the data was unexpected
        case invalidResponse(data: Any)
    }
}
