//
//  HTTPProvider.swift
//  Chameleon
//
//  Created by Ian Keen on 31/01/2016.
//  Copyright © 2016 HitchPlanet. All rights reserved.
//

import Foundation
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

private protocol StringType {
    var string: String { get }
}
extension String: StringType {
    var string: String { return self }
}
extension Dictionary where Key: CaseInsensitiveStringRepresentable, Value: StringType {
    private func makeHeaders() -> Headers {
        var headers = [CaseInsensitiveString: String]()
        for (key, value) in self {
            headers.updateValue(value.string, forKey: key.caseInsensitiveString)
        }
        return Headers(headers)
    }
}
extension Dictionary where Key: StringType, Value: StringType {
    private func makeQuery() -> [String: CustomStringConvertible] {
        let charSet = CharacterSet(charactersIn: uriQueryAllowed.joined(separator: ""))
        var query = [String: CustomStringConvertible]()
        
        for (key, value) in self {
            guard let value = value.string.addingPercentEncoding(withAllowedCharacters: charSet) else { continue }
            query.updateValue(value, forKey: key.string)
        }
        return query
    }
}

private let uriQueryAllowed: [String] = ["!", "$", "&", "\'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "=", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "_", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "~"]
