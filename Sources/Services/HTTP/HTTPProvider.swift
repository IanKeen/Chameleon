//
//  HTTPProvider.swift
//  Chameleon
//
//  Created by Ian Keen on 31/01/2016.
//  Copyright © 2016 HitchPlanet. All rights reserved.
//

import VaporTLS
import S4
import Engine

/// Standard implementation of a HTTPService
final public class HTTPProvider: HTTPService {
    //MARK: - Public
    public init() { }
    
    public func perform(with request: HTTPRequest) throws -> JSON {
        do {
            guard let absoluteString = request.url.absoluteString
                else { throw HTTPServiceError.invalidURL(url: request.url.absoluteString ?? "") }
            
            let response: HTTPResponse
            
            do {
                let headers = request.headers ?? [:]
                let query = request.parameters ?? [:]
                response = try HTTPClient<TLSClientStream>.request(
                    request.clientMethod,
                    absoluteString,
                    headers: headers.makeHeaders(),
                    query: query.makeQuery()
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
            
            do {
                guard let bytes = response.body.bytes else { throw HTTPServiceError.invalidResponse(data: response.body) }
                return try JSON.parse(bytes)
                
            } catch let error {
                throw HTTPServiceError.internalError(error: error)
            }
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
private extension Collection where Iterator.Element == (key: String, value: String) {
    private func makeHeaders() -> Headers {
        var headers = [CaseInsensitiveString: String]()
        for (key, value) in self {
            headers[key.caseInsensitiveString] = value
        }
        return Headers(headers)
    }
    private func makeQuery() -> [String: CustomStringConvertible] {
        var query = [String: CustomStringConvertible]()
        
        for (key, value) in self {
            guard
                let bytes = try? percentEncoded(value.bytes),
                let encoded = try? String(data: Data(bytes)) else { continue }
            
            query[key] = encoded
        }
        return query
    }
}
private extension URI {
    private var absoluteString: String? {
        /*
         foo://user:pass@example.com:8042/over/there?name=ferret#nose
         \_/   \_______/ \_________/ \__/ \________/ \_________/ \__/
         |         |          |       |        |          |       |
         scheme  userInfo    host    port     path      query   fragment
         */
        var result = ""
        if let scheme = self.scheme { result += "\(scheme)://" }
        if let userInfo = self.userInfo { result += "\(userInfo.username):\(userInfo.password)@" }
        if let host = self.host { result += host }
        if let port = self.port { result += ":\(port)" }
        if let path = self.path { result += (path.hasPrefix("/") ? "" : "/") + path }
        if let query = self.query { result += "?\(query)" }
        if let fragment = self.fragment { result += "#\(fragment)" }
        
        return result
    }
}
