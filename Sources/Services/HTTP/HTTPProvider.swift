//
//  HTTPProvider.swift
//  Chameleon
//
//  Created by Ian Keen on 31/01/2016.
//  
//

import VaporTLS
import HTTP

/// Standard implementation of a HTTPService
final public class HTTPProvider: HTTPService {
    //MARK: - Public
    public init() { }
    
    public func perform(with request: HTTPRequest) throws -> (headers: [String: String], json: [String: Any]) {
        do {
            // For some reason on linux `absoluteString` _isn't_ `String?` - just `String`
            //
            //(╯°□°）╯︵ ┻━┻
            let value: String? = request.url.absoluteString
            guard let absoluteString = value
                else { throw HTTPServiceError.invalidURL(url: request.url.absoluteString ?? "") }
            
            let response: Response
            
            do {
                let headers = request.headers ?? [:]
                let parameters = request.parameters ?? [:]
                let body = request.body?.makeJSONObject().makeBody() ?? []
                response = try Client<TLSClientStream>.request(
                    request.method.requestMethod,
                    absoluteString,
                    headers: headers.makeHeaders(),
                    query: parameters.makeQueryParameters(),
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
            
            return (
                headers: response.headers.makeDictionary(),
                json: response.json?.makeDictionary() ?? [:]
            )
        }
    }
}

