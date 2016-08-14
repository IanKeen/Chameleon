
public extension Channel {
    public func renamed(to newName: String) -> Channel {
        return Channel(
            id: self.id,
            name: newName,
            created: self.created,
            creator: self.creator,
            is_channel: self.is_channel,
            is_general: self.is_general,
            is_archived: self.is_archived,
            is_member: self.is_member,
            members: self.members,
            topic: self.topic,
            purpose: self.purpose,
            last_read: self.last_read,
            latest: self.latest,
            unread_count: self.unread_count,
            unread_count_display: self.unread_count_display
        )
    }
}
