import Common

public struct Message {
    public let subtype: MessageSubType?
    public let timestamp: String
    
    public let text: String?
    
    public let channel: FailableBox<Target>?
    public let user: User?
    public let inviter: User?
    
    public let bot: User?
    public let username: String?
    public let icons: [String: Any]?
    
    public let hidden: Bool
    public let deleted_ts: String?
    public let topic: String?
    public let purpose: String?
    public let old_name: String?
    public let name: String?
    
    public let members: [User]?
    public let file: File?
    public let upload: Bool
    public let comment: Any?
    
    public let item_type: MessageItemType?
    public let item: [String: Any]?
    
    public let is_starred: Bool
    public let pinned_to: FailableBox<[Target]>?
    
    public let reactions: [Reaction]?
    
    public let edited: MessageEdit?
    
    public let attachments: [MessageAttachment]?
    public let response_type: MessageResponseType?
    public let replace_original: Bool?
    public let delete_original: Bool?
}
