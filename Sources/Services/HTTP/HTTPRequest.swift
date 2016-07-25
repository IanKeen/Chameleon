//
//  HTTPRequest.swift
//  Chameleon
//
//  Created by Ian Keen on 26/09/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

#if !os(Linux)
import Foundation
#endif

/// Represents a HTTP Request
public struct HTTPRequest {
    public let method: Method
    public let url: URL
    public let port: Int
    public let parameters: [String: String]?
    public let headers: [String: String]?
    
    public init(method: Method, url: URL, port: Int = 443, parameters: [String: String]? = nil, headers: [String: String]? = nil) {
        self.method = method
        self.url = url
        self.port = port
        self.parameters = parameters
        self.headers = headers
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
