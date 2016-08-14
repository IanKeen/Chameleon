
/// Describes a range of errors that can occur when attempting to use the the webapi
public enum WebAPIError: Error, CustomStringConvertible {
    /// Tried to perform an authenticated method but no token is set
    case missingToken
    
    /// Something went wrong during execution
    case apiError(reason: String)
    
    /// The response was invalid or the data was unexpected
    case invalidResponse(json: [String: Any])
    
    public var description: String {
        switch self {
        case .invalidResponse(let json):
            return "The response was invalid:\n\(json)"
        case .apiError(let reason):
            return "The API returned the error: \(reason)"
        case .missingToken:
            return "Token is required for authenticated methods"
        }
    }
}
