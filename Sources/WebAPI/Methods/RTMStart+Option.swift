import Common

/// Defines the options available when sending a message.
public enum RTMStartOption {
    /// Return timestamp only for latest message object of each channel (improves performance).
    case simpleLatest(Bool)
    
    /// Skip unread counts for each channel (improves performance).
    case noUnreads(Bool)
    
    /// Returns MPIMs to the client in the API response.
    case mpimAware(Bool)
}

extension RTMStartOption: OptionRepresentable {
    public var key: String {
        switch self {
        case .simpleLatest: return "simple_latest"
        case .noUnreads: return "no_unreads"
        case .mpimAware: return "mpim_aware"
        }
    }
    public var value: String {
        switch self {
        case .simpleLatest(let value): return String(value)
        case .noUnreads(let value): return String(value)
        case .mpimAware(let value): return String(value)
        }
    }
}

extension RTMStartOption {
    public init?(key: String, value: String) {
        if (key == "simple_latest") {
            self = .simpleLatest(Bool(stringLiteral: value))
            
        } else if (key == "no_unreads") {
            self = .noUnreads(Bool(stringLiteral: value))
            
        } else if (key == "mpim_aware") {
            self = .mpimAware(Bool(stringLiteral: value))
            
        } else {
            return nil
        }
    }
}
