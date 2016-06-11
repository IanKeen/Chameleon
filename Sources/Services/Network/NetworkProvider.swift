//
//  NetworkProvider.swift
//  Slack
//
//  Created by Ian Keen on 31/01/2016.
//  Copyright © 2016 HitchPlanet. All rights reserved.
//

import Foundation
import HTTPSClient
import String
import Jay

final public class NetworkProvider: NetworkProtocol {
    //MARK: - Public
    public init() { }
    
    public func makeRequest(request: NetworkRequest) throws -> JSON {
        do {
            let urlScheme: String? = request.url?.scheme //required because url.scheme seems to come through as String? on linux
            guard let url = request.url, let scheme = urlScheme, let host = url.host else { throw NetworkProtocolError.InvalidURL }
            
            let uriString = "\(scheme)://\(host)"
            let client = try HTTPSClient.Client(uri: uriString)
            
            let path = url.absoluteString.substring(from: uriString.endIndex) + request.parameterString
            let headers = request.headers ?? [:]
            let bodyData = request.bodyData?.data ?? Data()
            
            var response = try client.send(
                method: request.clientMethod,
                uri: path,
                headers: headers.makeHeaders(),
                body: bodyData
            )
            let buffer = try response.body.becomeBuffer()
            
            return try Jay().typesafeJsonFromData(buffer.bytes)
        }
    }
}

private extension NetworkRequest {
    var clientMethod: S4.Method {
        switch self.method {
        case .GET: return .get
        case .PUT: return .put
        case .PATCH: return .patch
        case .POST: return .post
        case .DELETE: return .delete
        }
    }
    var bodyData: NSData? {
        guard let json = self.jsonBody else { return nil }
        
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
    func makeHeaders() -> Headers {
        var headers = [CaseInsensitiveString: Header]()
        for (key, value) in self {
            headers.updateValue(value.header, forKey: key.caseInsensitiveString)
        }
        return Headers(headers)
    }
}
