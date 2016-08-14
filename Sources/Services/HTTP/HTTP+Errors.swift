
/// Describes a range of errors that can occur when attempting to use the service
public enum HTTPError: Error, CustomStringConvertible {
    /// The provided URL was invalid
    case invalidURL(url: String)
    
    /// Something was wrong with the request data
    case clientError(code: Int, data: [String: Any]?)
    
    /// Something went wrong on the server
    case serverError(code: Int)
    
    /// The response was invalid or the data was unexpected
    case invalidResponse(data: Any)
    
    /// Something went wrong with an dependency
    case internalError(error: Error)
    
    public var description: String {
        switch self {
        case .invalidResponse(let data):
            return "The response was invalid:\n\(data)"
        case .invalidURL(let url):
            return "The provided url was invalid: \(url)"
        case .clientError(let code, let data):
            return "Client Error (\(code)): \(data)"
        case .serverError(let code):
            return "Server Error (\(code))"
        case .internalError(let error):
            let nestedDescription = (error as? CustomStringConvertible)?.description ?? String(error)
            return "Internal Error: \(nestedDescription)"
        }
    }
}
