//
//  Group+Extensions.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

public extension Group {
    public func renamed(to newName: String) -> Group {
        return Group(
            id: self.id,
            name: newName,
            created: self.created,
            creator: self.creator,
            is_group: self.is_group,
            is_archived: self.is_archived,
            is_mpim: self.is_mpim,
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
