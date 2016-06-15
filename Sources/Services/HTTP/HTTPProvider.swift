//
//  HTTPProvider.swift
//  Slack
//
//  Created by Ian Keen on 31/01/2016.
//  Copyright © 2016 HitchPlanet. All rights reserved.
//

import Foundation
import HTTPSClient
import String
import Jay

/// Standard implementation of the HTTPService
final public class HTTPProvider: HTTPService {
    //MARK: - Public
    public init() { }
    
    public func perform(with request: HTTPRequest) throws -> JSON {
        do {
            // (╯°□°）╯︵ ┻━┻
            //On Heroku scheme was coming through as Optional<String> even though the API says String
            let urlScheme: String? = request.url.scheme
            guard let scheme = urlScheme, let host = request.url.host else { throw HTTPServiceError.invalidURL }
            
            let response: Response
            
            do {
                let uriString = "\(scheme)://\(host)"
                let client = try HTTPSClient.Client(uri: uriString)
                
                let path = request.url.absoluteString.substring(from: uriString.endIndex) + request.parameterString
                let headers = request.headers ?? [:]
                let bodyData = request.bodyData?.data ?? []
                
                response = try client.send(
                    method: request.clientMethod,
                    uri: path,
                    headers: headers.makeHeaders(),
                    body: bodyData
                )
                
            } catch let error {
                throw HTTPServiceError.internalError(error: error)
            }
        
            //NOTE: There is an Int.between(_:and:clapming:) extension in Common.
            //      However it fails to build with a linker error which I wasn't able to fix yet
            //      So I'm falling back to this ugly syntax :( - for now...
            //
            if (400...499 ~= response.statusCode) {
                throw HTTPServiceError.clientError(code: response.statusCode, data: nil)
                
            } else if (500...599 ~= response.statusCode) {
                throw HTTPServiceError.serverError(code: response.statusCode)
            }
            
            do {
                let buffer = try response.body.becomeBuffer()
                return try Jay().typesafeJsonFromData(buffer.bytes)
                
            } catch let error {
                throw HTTPServiceError.internalError(error: error)
            }
        }
    }
}

//MARK: - Helpers
private extension HTTPRequest {
    var clientMethod: S4.Method {
        switch self.method {
        case .get: return S4.Method.get
        case .put: return S4.Method.put
        case .patch: return S4.Method.patch
        case .post: return S4.Method.post
        case .delete: return S4.Method.delete
        }
    }
    var bodyData: NSData? {
        guard let json = self.body else { return nil }
        
        do {
            let data = try Jay(formatting: .prettified).dataFromJson(json)
            return NSData(bytes: data, length: data.count)
        }
        catch { return nil }
    }
    var parameterString: String {
        let pairs = self.parameters?.flatMap { key, value -> String? in
            do {
                let param = try value.percentEncoded(allowing: CharacterSet.uriQueryAllowed)
                return "\(key)=\(param)"
            }
            catch { return nil }
        }
        let result = pairs?.joined(separator: "&") ?? ""
        return (result.isEmpty ? "" : "?\(result)")
    }
}

extension NSData: DataRepresentable {
    public var data: Data {
        return Data(pointer: UnsafePointer<Int8>(self.bytes), length: self.length)
    }
}

extension Dictionary where Key: CaseInsensitiveStringRepresentable, Value: HeaderRepresentable {
    private func makeHeaders() -> Headers {
        var headers = [CaseInsensitiveString: Header]()
        for (key, value) in self {
            headers.updateValue(value.header, forKey: key.caseInsensitiveString)
        }
        return Headers(headers)
    }
}
