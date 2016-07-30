//
//  IM.swift
//  Chameleon
//
//  Created by Ian Keen on 25/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public struct IM {
    public let id: String
    public let is_im: Bool
    public let is_open: Bool
    public let has_pins: Bool
    public let user: User
    public let created: Int
    public let is_user_deleted: Bool
    public let last_read: String
    public let latest: Message?
}
