import Models
import Services
import Common
import Foundation

/// Handler for the `chat.postMessage` endpoint
public struct ChatPostMessage: WebAPIMethod {
    public typealias SuccessParameters = (Void)
    
    //MARK: - Private Properties
    private let target: Target
    private let text: String
    private let response_type: MessageResponseType?
    private let options: [ChatPostMessageOption]
    private let customParameters: [String: String]?
    private let attachments: [MessageAttachment]?
    private let customUrl: URL?
    
    //MARK: - Lifecycle
    /**
     Creates a new `ChatPostMessage` instance
     
     - parameter target:           The `Target` to send the message to
     - parameter text:             The text to send
     - parameter response_type:    The `MessageResponseType` that determines how the message appears
     - parameter options:          `ChatPostMessage.Option`s to use
     - parameter customParameters: Custom parameters to send
     - parameter attachments:      Attachments to this message
     - parameter customUrl:        Allows for overridding the default url (generally used by responders)
     
     - Warning:                     Using a custom url will not use token authentication
     
     - returns: A new instance
     */
    public init(target: Target, text: String, response_type: MessageResponseType? = nil, options: [ChatPostMessageOption] = [], customParameters: [String: String]? = nil, attachments: [MessageAttachment]? = nil, customUrl: URL? = nil) {
        self.target = target
        self.text = text
        self.response_type = response_type
        self.options = options
        self.customParameters = customParameters
        self.attachments = attachments
        self.customUrl = customUrl
    }
    
    //MARK: - Public
    public var networkRequest: HTTPRequest {
        let encodedText = self.text
        
        var packet = [String: Any]()
        
        packet = packet + [
            "channel": self.target.id,
            "text": encodedText
        ]
        
        for (key, value) in options.makeParameters() {
            packet[key] = value
        }
        
        for (key, value) in self.customParameters ?? [:] {
            packet[key] = value
        }
        
        if let attachments = self.attachments?.encodedString {
            packet["attachments"] = attachments
        }
        
        if let response_type = response_type {
            packet["response_type"] = response_type.rawValue
        }
        
        return HTTPRequest(
            method: .post,
            url: self.customUrl ?? WebAPIURL("chat.postMessage"),
            body: packet
        )
    }
    public var requiresAuthentication: Bool {
        return (self.customUrl == nil)
    }
    public func handle(headers: [String: String], json: [String: Any], slackModels: SlackModels) throws -> SuccessParameters { }
}
