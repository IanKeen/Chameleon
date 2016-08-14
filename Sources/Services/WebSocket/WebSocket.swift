import Foundation

/// An abstraction representing an object capable of synchronous web sockets
public protocol WebSocket: class {
    /// Closure that is called when a connection is opened
    var onConnect: (() -> Void)? { get set }
    
    /// Closure that is called when a connection is closed with an error when applicable
    var onDisconnect: ((Error?) -> Void)? { get set }
    
    /// Closure that is called when receiving text data
    var onText: ((String) -> Void)? { get set }
    
    /// Closure that is called when receiving byte data
    var onData: ((Data) -> Void)? { get set }
    
    /// Closure that is called when an error occurs
    var onError: ((Error) -> Void)? { get set }
    
    /**
     Attempt to open a connection to a specified url
     
     - parameter url: The url to connect to
     - throws: A `WebSocketServiceError` with failure details
     */
    func connect(to url: String) throws
    
    /**
     Disconnect a connection
     */
    func disconnect()
    
    /**
     Send `[String: Any]` data
     
     - parameter json: `[String: Any]` to send
     */
    func send(_ json: [String: Any])
    
    /**
     Send `Data` data
     
     - parameter data: `Data` to send
     */
    func send(_ data: Data)
    
    /**
     Send `String` data
     
     - parameter string: `String` to send
     */
    func send(_ string: String)
}

/// Describes a range of errors that can occur when attempting to use the service
public enum WebSocketError: Error, CustomStringConvertible {
    /// The provided URL was invalid
    case invalidURL(url: String)
    
    /// Generic socket error
    case genericError(reason: String)
    
    /// Something went wrong with an dependency
    case internalError(error: Error)
    
    public var description: String {
        switch self {
        case .invalidURL(let url):
            return "The provided url was invalid: \(url)"
        case .internalError(let error):
            let nestedDescription = (error as? CustomStringConvertible)?.description ?? String(error)
            return "Internal Error: \(nestedDescription)"
        case .genericError(let reason):
            return "Generic Error: \(reason)"
        }
    }
}
