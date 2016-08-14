import Models
import Services

/// An abstraction representing an object that can execute and handle the response of a webapi method
public protocol WebAPIMethod {
    /// Represents the value(s) that will be returned by the `WebAPIMethod`
    associatedtype SuccessParameters
    
    /// The `HTTPRequest` used to execute the webapi method
    var networkRequest: HTTPRequest { get }
    
    /// A `Bool` to let `WebAPI` know if the `HTTPRequest` needs authentication (default: `true`)
    var requiresAuthentication: Bool { get }
    
    /**
     Handle the `[String: Any]` response from an executed `WebAPIMethod`
     
     - parameter headers:     The `[String: String]` of the request
     - parameter json:        The `[String: Any]` result
     - parameter slackModels: The `SlackModels` that can be used to create a `SlackModelBuilder` for constructing a type-safe response
     - throws: Any `Error` that might result from the handling of the `[String: Any]` response
     - returns: The result of handling the `[String: Any]`
     */
    func handle(headers: [String: String], json: [String: Any], slackModels: SlackModels) throws -> SuccessParameters
}

public extension WebAPIMethod {
    public var requiresAuthentication: Bool { return true }
}
