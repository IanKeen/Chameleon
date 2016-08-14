
/// An abstraction representing an object capable of synchronous http requests
public protocol HTTP: class {
    /**
     Performs a _synchronous_ http request
     
     - parameter with: A `HTTPRequest` to execute
     - throws: A `HTTPServiceError` with failure details
     - returns: A tuple containing the `Header`s and `[String: Any]` response
     */
    func perform(with: HTTPRequest) throws -> (headers: [String: String], json: [String: Any])
}
