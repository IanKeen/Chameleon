//
//  HTTP+Conversion.swift
//  Chameleon
//
//  Created by Ian Keen on 29/07/2016.
//
//

import Vapor
import HTTP
import Foundation


//
// Provides the translation to/from Vapor data types and Swift standard types
//


//MARK: - HTTP Method
extension HTTPRequestMethod {
    var requestMethod: HTTP.Method {
        switch self {
        case .get: return .get
        case .put: return .put
        case .patch: return .patch
        case .post: return .post
        case .delete: return .delete
        }
    }
}

//MARK: - Headers
extension Collection where Iterator.Element == (key: String, value: String) {
    func makeHeaders() -> [HeaderKey: String] {
        var headers = [HeaderKey: String]()
        for (key, value) in self {
            headers[HeaderKey(key)] = value
        }
        return headers
    }
}
extension Collection where Iterator.Element == (key: HeaderKey, value: String) {
    func makeDictionary() -> [String: String] {
        var result = [String: String]()
        for (key, value) in self {
            result[key.key] = value
        }
        return result
    }
}

//MARK: - Query
extension Collection where Iterator.Element == (key: String, value: String) {
    func makeQueryParameters() -> [String: CustomStringConvertible] {
        var query = [String: CustomStringConvertible]()
        
        for (key, value) in self {
            guard
                let bytes = try? percentEncoded(value.bytes),
                let encoded = String(data: Data(bytes: bytes), encoding: .utf8)
                else { continue }
            
            query[key] = encoded
        }
        return query
    }
}
