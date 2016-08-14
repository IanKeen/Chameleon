
import Models
import Services
import Foundation

/// Handler for the `emoji.list` endpoint
public struct EmojiList: WebAPIMethod {
    public typealias SuccessParameters = ([CustomEmoji])
    
    //MARK: - Lifecycle
    /**
     Create a new `EmojiList` instance
     
     - returns: A new instance
     */
    public init() { }
    
    //MARK: - Public
    public var networkRequest: HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: WebAPIURL("emoji.list")
        )
    }
    public func handle(headers: [String: String], json: [String: Any], slackModels: SlackModels) throws -> SuccessParameters {
        guard var emoji = json["emoji"] as? [String: Any] else { return [] }
        
        return emoji.flatMap { (key: String, value: Any) -> CustomEmoji? in
            guard
                let string = value as? String,
                let alias = string.components(separatedBy: "alias:").last
                else { return nil }
            
            let imageUrl = (emoji[alias] as? String) ?? (value as? String) ?? ""
            return CustomEmoji(name: key, imageUrl: imageUrl)
        }
    }
}
