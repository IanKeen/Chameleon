//
//  NetworkProtocol.swift
//  Slack
//
//  Created by Ian Keen on 26/09/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import Jay

public enum NetworkProtocolError: ErrorProtocol, Equatable {
    case InvalidURL
    case ClientError([String: Any]?)
    case ServerError
    case InvalidResponse(Any)
}
public func ==(lhs: NetworkProtocolError, rhs: NetworkProtocolError) -> Bool {
    switch (lhs, rhs) {
    case (.ServerError, .ServerError): return true
    case (.ClientError(let lhs_data), .ClientError(let rhs_data)):
        guard let lhs_data = lhs_data, let rhs_data = rhs_data else { return true }
        return (Array(lhs_data.keys) == Array(rhs_data.keys))
    default: return false
    }
}

public protocol NetworkProtocol: class {
    func makeRequest(request: NetworkRequest) throws -> JSON
}
