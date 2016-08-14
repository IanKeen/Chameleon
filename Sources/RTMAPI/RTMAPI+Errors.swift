
/// Describes a range of errors that can occur when attempting to use the the realtime messaging api
public enum RTMAPIError: Error, CustomStringConvertible {
    /// The response was invalid or the data was unexpected
    case invalidResponse(json: [String: Any])
    
    public var description: String {
        switch self {
        case .invalidResponse(let json):
            return "The response was invalid:\n\(json)"
        }
    }
}

/// Describes a range of errors that can occur when attempting to build RTMAPI events from `[String: Any]`
public enum RTMAPIEventBuilderError: Error, CustomStringConvertible {
    /// A parent builder error and the nested error `error`
    case error(type: RTMAPIEventBuilder.Type, error: Error)
    
    /// No builder for the provided type exists
    case noAvailableBuilder(type: String)
    
    /// The builder in not capable of handling the provided `[String: Any]`
    case invalidBuilder(builder: Any.Type)
    
    /// The response was invalid or the data was unexpected
    case invalidResponse(json: [String: Any])
    
    public var description: String {
        switch self {
        case .error(let type, let error):
            let nestedDescription = (error as? CustomStringConvertible)?.description ?? String(error)
            return "\(type): \(nestedDescription)"
        case .invalidBuilder(let builder):
            return "The chosen builder: '\(String(builder.self))' cannot handled to provided data"
        case .invalidResponse(let json):
            return "The response was invalid:\n\(json)"
        case .noAvailableBuilder(let type):
            return "There is no builder available for the event-type: \(type)"
        }
    }
}

/**
 Encapsulates an attempt to build a RTMAPI event object.
 By wrapping all attempts in this function we are able to accurately trace any
 nested errors to their source accurately.
 
 - parameter op: The closure containing the build attempt
 - throws: A `RTMAPIEventBuilderError.error` containing further details of the failure
 - returns: A new `RTMAPIEvent`
 */
public func tryMake(_ type: RTMAPIEventBuilder.Type, _ op: @autoclosure () throws -> RTMAPIEvent) throws -> RTMAPIEvent {
    do { return try op() }
    catch let error { throw RTMAPIEventBuilderError.error(type: type, error: error) }
}
