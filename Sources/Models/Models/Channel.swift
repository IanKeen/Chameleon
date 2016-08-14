
public struct Channel {
    public let id: String
    public let name: String
    
    public let created: Int
    public let creator: User
    
    public let is_channel: Bool
    public let is_general: Bool
    public let is_archived: Bool
    public let is_member: Bool
    
    public let members: [User]?
    
    public let topic: Topic?
    public let purpose: Purpose?
    
    public let last_read: String?
    public let latest: Message?
    
    public let unread_count: Int?
    public let unread_count_display: Int?
}
