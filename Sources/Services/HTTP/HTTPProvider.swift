import Common
import VaporTLS
import HTTP

/// Standard implementation of a HTTP
final public class HTTPProvider: HTTP {
    //MARK: - Public
    public init() { }
    
    public func perform(with request: HTTPRequest) throws -> (headers: [String: String], json: [String: Any]) {
        do {
            // For some reason on linux `absoluteString` _isn't_ `String?` - just `String`
            //
            //(╯°□°）╯︵ ┻━┻
            let value: String? = request.url.absoluteString
            guard let absoluteString = value
                else { throw HTTPError.invalidURL(url: String(request.url)) }
            
            let response: Response
            
            do {
                let headers = request.headers ?? [:]
                let parameters = request.parameters ?? [:]
                let body = try request.body?.makeJSONObject().makeBody() ?? []
                response = try Client<TLSClientStream>.request(
                    request.method.method,
                    absoluteString,
                    headers: headers.makeHeaders(),
                    query: parameters.makeQueryParameters(),
                    body: body
                )
                
            } catch let error {
                throw HTTPError.internalError(error: error)
            }
            
            if (response.status.statusCode.between(400, and: 499)) {
                throw HTTPError.clientError(code: response.status.statusCode, data: nil)
                
            } else if (response.status.statusCode.between(500, and: 599)) {
                throw HTTPError.serverError(code: response.status.statusCode)
            }
            
            return (
                headers: response.headers.makeDictionary(),
                json: response.json?.makeDictionary() ?? [:]
            )
        }
    }
}

