//
//  Group.swift
//  Chameleon
//
//  Created by Ian Keen on 25/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public struct Group {
    public let id: String
    public let name: String
    
    public let created: Int
    public let creator: User
    
    public let is_group: Bool
    public let is_archived: Bool
    public let is_mpim: Bool
    
    public let members: [User]?
    
    public let topic: Topic?
    public let purpose: Purpose?
    
    public let last_read: Double?
    public let latest: Message?
    
    public let unread_count: Int?
    public let unread_count_display: Int?
}
