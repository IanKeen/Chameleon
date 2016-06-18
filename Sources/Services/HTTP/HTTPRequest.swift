//
//  HTTPRequest.swift
//  Chameleon
//
//  Created by Ian Keen on 26/09/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import Foundation
import Jay

/// Represents a HTTP Request
public struct HTTPRequest {
    public let method: Method
    public let url: NSURL
    public let parameters: [String: String]?
    public let headers: [String: String]?
    public let body: JSON?
    
    public init(method: Method, url: NSURL, parameters: [String: String]? = nil, headers: [String: String]? = nil, body: JSON? = nil) {
        self.method = method
        self.url = url
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
}

public extension HTTPRequest {
    /// Available HTTP Methods
    public enum Method: String {
        case get
        case put
        case patch
        case post
        case delete
    }
}
