import Foundation

//MARK: Typealiases
public typealias RouteHandler = (
    url: URL,
    headers: [String: String],
    json: [String: Any]?
    ) throws -> HTTPServerResponse?

//MARK: - HTTPServer
public protocol HTTPServer {
    func start()
    
    func respond(
        to method: HTTPRequestMethod,
        at path: [String],
        with handler: RouteHandler
    )
    
    func respond<T: AnyObject>(
        to method: HTTPRequestMethod,
        at path: [String],
        with object: T,
        _ function: (T) -> RouteHandler
    )
}

//MARK: - Responses
public protocol HTTPServerResponse {
    var code: Int { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
}

extension URL: HTTPServerResponse {
    public var code: Int { return 307 }
    public var headers: [String : String]? {
        let url: String? = self.absoluteString
        guard let urlString = url else { fatalError("Invalid URL: \(self)") }
        
        return ["Location": urlString]
    }
    public var body: [String : Any]? { return nil }
}
