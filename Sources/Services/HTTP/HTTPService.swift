//
//  HTTPService.swift
//  Chameleon
//
//  Created by Ian Keen on 26/09/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import Vapor

/// An abstraction representing an object capable of synchronous http requests
public protocol HTTPService: class {
    /**
     Performs a _synchronous_ http request
     
     - parameter with: A `HTTPRequest` to execute
     - throws: A `HTTPServiceError` with failure details
     - returns: A `JSON` response
     */
    func perform(with: HTTPRequest) throws -> JSON
}

/// Describes a range of errors that can occur when attempting to use the service
public enum HTTPServiceError: ErrorProtocol, Equatable, CustomStringConvertible {
    /// The provided URL was invalid
    case invalidURL(url: String)
    
    /// Something was wrong with the request data
    case clientError(code: Int, data: JSON?)
    
    /// Something went wrong on the server
    case serverError(code: Int)
    
    /// The response was invalid or the data was unexpected
    case invalidResponse(data: Any)
    
    /// Something went wrong with an dependency
    case internalError(error: ErrorProtocol)
    
    public var description: String {
        switch self {
        case .invalidResponse(let data):
            return "The response was invalid:\n\(data)"
        case .invalidURL(let url):
            return "The provided url was invalid: \(url)"
        case .clientError(let code, let data):
            return "Client Error (\(code)): \(data)"
        case .serverError(let code):
            return "Server Error (\(code))"
        case .internalError(let error):
            let nestedDescription = (error as? CustomStringConvertible)?.description ?? String(error)
            return "Internal Error: \(nestedDescription)"
        }
    }
}

public func ==(lhs: HTTPServiceError, rhs: HTTPServiceError) -> Bool {
    switch (lhs, rhs) {
    case (.serverError(let lhs_code), .serverError(let rhs_code)):
        return (lhs_code == rhs_code)
        
    case (.clientError(let lhs_code, let lhs_data), .clientError(let rhs_code, let rhs_data)):
        return (lhs_code == rhs_code) && (lhs_data == rhs_data)
        
    default: return false
    }
}
