import Foundation

/// Represents a HTTP Request
public struct HTTPRequest {
    public let method: HTTPRequestMethod
    public let url: URL
    public let port: Int
    public let parameters: [String: String]?
    public internal(set) var headers: [String: String]?
    public let body: [String: Any]?
    
    public init(method: HTTPRequestMethod, url: URL, port: Int = 443, parameters: [String: String]? = nil, headers: [String: String]? = nil, body: [String: Any]? = nil) {
        self.method = method
        self.url = url
        self.port = port
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
}

/// Available HTTP Methods
public enum HTTPRequestMethod: String {
    case get
    case put
    case patch
    case post
    case delete
}
