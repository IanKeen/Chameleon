
/// Describes a range of errors that can occur when using storage
public enum StorageError: Error, CustomStringConvertible {
    /// The connection url supplied is invalid
    case invalidURL(url: String)
    
    /// The value being stored is invalid
    case invalidValue(value: Any)
    
    /// The value being stored is unsupported
    case unsupportedType(value: Any.Type)
    
    /// Something went wrong with an dependency
    case internalError(error: Error)
    
    public var description: String {
        switch self {
        case .invalidURL(let url):
            return "The url provided was invalid: \(url)"
        case .invalidValue(let value):
            return "The value supplied was invalid: \(value)"
        case .unsupportedType(let value):
            return "The type of value supplied was unsupported: \(String(value.self))"
        case .internalError(let error):
            let nestedDescription = (error as? CustomStringConvertible)?.description ?? String(error)
            return "Internal Error: \(nestedDescription)"
        }
    }
}
