import Models
import Common
import Services
import Foundation

/// Provides access to the Slack realtime messaging api
public final class RTMAPI {
    //MARK: - Private Properties
    private let websocket: WebSocket
    private var pingPongInterval: TimeInterval = 3.0
    private var pingPongTimer: CancellableDispatchOperation?
    
    //MARK: - Public Events
    /// Closure that is called when a websocket connection is made
    public var onConnected: (() -> Void)?
    
    /// Closure that is called when a websocket connection is closed with an error when applicable
    public var onDisconnected: ((error: Error?) -> Void)?
    
    /// Closure that is called when an error occurs
    public var onError: ((error: Error) -> Void)?
    
    /// Closure that is fired when a realtime messaging event occurs
    public var onEvent: ((event: RTMAPIEvent) -> Void)?
    
    //MARK: - Public Properties
    /// A closure that needs to be set before the rtmapi can correctly serialise and build responses.
    public var slackModels: (() -> SlackModels)?
    
    //MARK: - Lifecycle
    /**
     Create a new `RTMAPI` instance.
     
     - parameter websocket: A `WebSocket` that will be used for the websocket connection
     - returns: New `RTMAPI` instance.
     */
    public init(websocket: WebSocket) {
        self.websocket = websocket
        self.bindToSocketEvents()
    }
    
    //MARK: - Public
    /**
     Attempt a connection to a slack websocket url.
     
     - parameter url:              The url to attempt a connection to
     - parameter pingPongInterval: The number of seconds between sending each ping
     - throws: A `WebSocketServiceError` with failure details
     */
    public func connect(to url: String, pingPongInterval: TimeInterval) throws {
        self.pingPongInterval = pingPongInterval
        try self.websocket.connect(to: url)
    }
    
    /**
     Disconnect the websocket.
     */
    public func disconnect() {
        self.disconnect(error: nil)
    }
    private func disconnect(error: Error? = nil) {
        self.websocket.disconnect()
        self.onDisconnected?(error: error)
    }
    
    //TODO: sending messages via RTM
    //https://api.slack.com/rtm
    //remember to handle rate limiting once this is implemented
    //https://api.slack.com/docs/rate-limits
    
}

//MARK: - Ping Pong
private extension RTMAPI {
    private func startPingPong() {
        self.stopPingPong()
        
        let ping = {
            sleep(UInt32(self.pingPongInterval))
            self.sendPingPong()
            self.startPingPong()
        }
        
        self.pingPongTimer = inBackground(function: ping)
    }
    private func stopPingPong() {
        guard let pingPongTimer = self.pingPongTimer else { return }
        _ = try? pingPongTimer.cancel()
        self.pingPongTimer = nil
    }
    private func sendPingPong() {
        //`timestamp` will come back in the response
        //could potentially be used later for checking
        //latency as suggested in the docs
        
        let packet: [String: Any] = [
            "id": Int.random(min: 1, max: 999999),
            "type": "ping",
            "timestamp": Int(Date().timeIntervalSince1970)
        ]
        
        self.websocket.send(packet)
    }
}

//MARK: - Socket
private extension RTMAPI {
    private func bindToSocketEvents() {
        self.websocket.onConnect = { [weak self] in self?.websocketOnConnect() }
        self.websocket.onDisconnect = { [weak self] in self?.websocketOnDisconnect(error: $0) }
        self.websocket.onText = { [weak self] in self?.websocketOn(text: $0) }
        self.websocket.onData = { [weak self] in self?.websocketOn(data: $0) }
        self.websocket.onError = { [weak self] in self?.websocketOn(error: $0) }
    }
    
    private func websocketOnConnect() {
        self.onConnected?()
    }
    private func websocketOnDisconnect(error: Error?) {
        self.stopPingPong()
        self.onDisconnected?(error: error)
    }
    
    private func websocketOn(text: String) {
        do {
            let json = text.makeDictionary()
            let eventBuilder = try RTMAPIEvent.makeEventBuilder(withJson: json)
            
            let event = try tryMake(
                eventBuilder,
                try eventBuilder.make(
                    withJson: json,
                    builderFactory: SlackModelBuilder.make(models: self.slackModels?())
                )
            )
            
            if case .hello = event { self.startPingPong() }
            
            self.onEvent?(event: event)
            
        } catch let error {
            self.onError?(error: error)
        }
    }
    private func websocketOn(data: Data) {
        print("DATA: \(data)") //TODO: unused at this point
    }
    private func websocketOn(error: Error) {
        self.onError?(error: error)
        self.disconnect(error: error)
    }
}
