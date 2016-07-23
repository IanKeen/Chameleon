//
//  HTTPProvider.swift
//  Chameleon
//
//  Created by Ian Keen on 31/01/2016.
//  Copyright © 2016 HitchPlanet. All rights reserved.
//

import Foundation
import VaporTLS
import Engine
import C7

/// Standard implementation of a HTTPService
final public class HTTPProvider: HTTPService {
    //MARK: - Public
    public init() { }
    
    public func perform(with request: HTTPRequest) throws -> (Headers, JSON) {
        do {
            guard let absoluteString = request.url.absoluteString
                else { throw HTTPServiceError.invalidURL(url: request.url.absoluteString ?? "") }
            
            let response: HTTPResponse
            
            do {
                let headers = request.headers ?? [:]
                let query = request.parameters ?? [:]
                let body = request.body?.makeBody() ?? []
                response = try HTTPClient<TLSClientStream>.request(
                    request.clientMethod,
                    absoluteString,
                    headers: headers.makeHeaders(),
                    query: query.makeQuery(),
                    body: body
                )
                
            } catch let error {
                throw HTTPServiceError.internalError(error: error)
            }
        
            //NOTE: There is an Int.between(_:and:clapming:) extension in Common.
            //      However it fails to build with a linker error which I wasn't able to fix yet
            //      So I'm falling back to this ugly syntax :( - for now...
            //
            if (400...499 ~= response.status.statusCode) {
                throw HTTPServiceError.clientError(code: response.status.statusCode, data: nil)
                
            } else if (500...599 ~= response.status.statusCode) {
                throw HTTPServiceError.serverError(code: response.status.statusCode)
            }
            
            return (response.headers, response.json ?? .null)
        }
    }
}

//MARK: - Helpers
private extension HTTPRequest {
    var clientMethod: Engine.Method {
        switch self.method {
        case .get: return .get
        case .put: return .put
        case .patch: return .patch
        case .post: return .post
        case .delete: return .delete
        }
    }
}

extension Collection where Iterator.Element == (key: String, value: String) {
    private func makeHeaders() -> Headers {
        var headers = [CaseInsensitiveString: String]()
        for (key, value) in self {
            headers[key.caseInsensitiveString] = value
        }
        return Headers(headers)
    }
    private func makeQuery() -> [String: CustomStringConvertible] {
        let charSet = CharacterSet(charactersIn: uriQueryAllowed.joined(separator: ""))
        var query = [String: CustomStringConvertible]()
        
        for (key, value) in self {
            guard let value = value.addingPercentEncoding(withAllowedCharacters: charSet) else { continue }
            query[key] = value
        }
        return query
    }
}

