//
// These are internal helpers used to convert between Vapor types and Swift standard types
//

import Common
import HTTP
import JSON
import URI

#if os(Linux)
    typealias URL = Foundation.NSURL
    typealias Data = Foundation.NSData
#else
    import struct Foundation.URL
    import struct Foundation.Data
#endif

//MARK: - Headers
extension Sequence where Iterator.Element == (key: HeaderKey, value: String) {
    func makeDictionary() -> [String: String] {
        return Dictionary<String, String>(self.map({ ($0.key, $1) }))
    }
}
extension Dictionary where Key: StringType, Value: StringType {
    func makeHeaders() -> [HeaderKey: String] {
        return Dictionary<HeaderKey, String>(self.map({ (HeaderKey($0.string), $1.string) }))
    }
}

//MARK: - Query
extension Dictionary where Key: StringType, Value: StringType {
    func makeQueryParameters() -> [String: CustomStringConvertible] {
        let input = self.flatMap { key, value -> (String, CustomStringConvertible)? in
            guard
                let bytes = try? percentEncoded(value.string.bytes),
                let encoded = String(data: Data(bytes: bytes), encoding: .utf8)
                else { return nil }
            
            return (key.string, encoded)
        }
        return Dictionary<String, CustomStringConvertible>(input)
    }
}

//MARK: - JSON
extension JSON {
    var any: Any? {
        switch self {
        case .null: return nil
        case .string(let value): return value
        case .bool(let value): return value
        case .number(let number):
            switch number {
            case .int(let value): return value
            case .double(let value): return value
            case .uint(let value): return value
            }
        case .array(let value):
            return value.flatMap { $0.any }
        case .object(let dict):
            var result = [String: Any]()
            for (key, value) in dict {
                guard let value = value.any else { continue }
                result[key] = value
            }
            return result
        }
    }
    func makeDictionary() -> [String: Any]? {
        guard let value = self.any as? [String: Any] else { return nil }
        return value
    }
}
extension Dictionary where Key: StringType, Value: Any {
    func makeJSONObject() throws -> JSON {
        let input: [(String, JSONRepresentable)] = self.flatMap { key, value in
            guard let value = value as? JSONRepresentable else { return nil }
            return (key.string, value)
        }
        return try JSON(Dictionary<String, JSONRepresentable>(input))
    }
}

//MARK: - HTTP Method
extension HTTPRequestMethod {
    var method: Method {
        switch self {
        case .get: return .get
        case .put: return .put
        case .patch: return .patch
        case .post: return .post
        case .delete: return .delete
        }
    }
}

//MARK: - Response
extension HTTPServerResponse {
    func makeResponse() throws -> Response {
        let headers = self.headers?.makeHeaders() ?? [:]
        let body = try self.body?.makeJSONObject().makeBody() ?? .data([])
        
        return Response(
            status: Status(statusCode: self.code),
            headers: headers,
            body: body
        )
    }
}

//MARK: - URI
extension URI {
    func makeURL() -> URL {
        var string = "\(scheme)://\(self.host)"
        if let port = self.port {
            string += ":\(port)"
        }
        string += self.path
        
        if let query = self.query {
            string += "?\(query)"
        }
        if let fragment = self.fragment {
            string += "#\(fragment)"
        }
        
        guard let url = URL(string: string)
            else { fatalError("Invalid URL: \(string)") }
        
        return url
    }
}

