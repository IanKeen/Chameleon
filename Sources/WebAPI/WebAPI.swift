import Services
import Models
import Common

/// Provides access to the Slack webapi
public final class WebAPI {
    //MARK: - Private
    private let http: HTTP
    
    //MARK: - Public
    /// A closure that needs to be set before the webapi can correctly serialise and build responses.
    public var slackModels: (() -> SlackModels)?
    
    //The token to use in authenticated webapi requests
    public var token: String?
    
    //MARK: - Lifecycle
    /**
     Create a new `WebAPI` instance.
     
     - parameter http:  The `HTTP` to use when making requests
     - returns: New `WebAPI` instance
     */
    public init(http: HTTP) {
        self.http = http
    }
    
    //MARK: - Public Functions
    /**
     Executes a webapi request using the provided `WebAPIMethod`.
     
     NOTE: Will crash if `.slackModels` has not been set
     
     - parameter method: A `WebAPIMethod` to execute
     - throws: Can throw `WebAPI.Error`, `HTTPServiceError` or a custom error from the provided `WebAPIMethod`
     - returns: The values specified in the `WebAPIMethod`
     */
    public func execute<Method: WebAPIMethod>(_ method: Method) throws -> Method.SuccessParameters {
        guard let slackModels = self.slackModels else { fatalError("Please set `slackModels`") }
        
        let request = try self.request(for: method)
        let (headers, json) = try self.http.perform(with: request)
        
        try self.checkForError(in: json)
        
        return try method.handle(headers: headers, json: json, slackModels: slackModels())
    }
}

//MARK: - Helpers
private extension WebAPI {
    private func request<Method: WebAPIMethod>(for method: Method) throws -> HTTPRequest {
        let request = self.requestWithHeaders(request: method.networkRequest)
        
        guard method.requiresAuthentication else { return request }
        guard let token = self.token else { throw WebAPIError.missingToken }
        
        //Copy the request, inserting the token
        return HTTPRequest(
            method: request.method,
            url: request.url,
            parameters: request.parameters + ["token": token],
            headers: request.headers,
            body: request.body
        )
    }
    private func requestWithHeaders(request: HTTPRequest) -> HTTPRequest {
        guard request.method == .post else { return request }
        
        //Copy the request, inserting the headers
        return HTTPRequest(
            method: request.method,
            url: request.url,
            parameters: request.parameters,
            headers: request.headers + ["Content-Type": "application/json"],
            body: request.body
        )
    }
    private func checkForError(in json: [String: Any]) throws {
        if let error = json["error"] as? String {
            throw WebAPIError.apiError(reason: error)
        }
    }
}
