//
//  NetworkRequest.swift
//  Slack
//
//  Created by Ian Keen on 26/09/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import Foundation
import Jay

public struct NetworkRequest {
    public let method: Method
    public let url: NSURL?
    public let parameters: [String: String]?
    public let headers: [String: String]?
    public let jsonBody: JSON?
    
    public init(method: Method, url: NSURL?, parameters: [String: String]?, headers: [String: String]?, jsonBody: JSON?) {
        self.method = method
        self.url = url
        self.parameters = parameters
        self.headers = headers
        self.jsonBody = jsonBody
    }
}

public extension NetworkRequest {
    public enum Method: String {
        case GET
        case PUT
        case PATCH
        case POST
        case DELETE
    }
}

public extension NetworkRequest {
    public enum Error: ErrorProtocol {
        case InvalidURL(String)
    }
}
