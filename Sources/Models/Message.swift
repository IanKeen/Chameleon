//
//  Message.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Common

public struct Message {
    public let subtype: SubType?
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
    public let comment: AnyObject?
    
    public let item_type: ItemType?
    public let item: [String: Any]?
    
    public let is_starred: Bool
    public let pinned_to: FailableBox<[Target]>?
    
    public let reactions: [Reaction]?
    
    public let edited: Edit?
    
    public let attachments: [Attachment]?
    public let response_type: ResponseType?
    public let replace_original: Bool?
    public let delete_original: Bool?
}
