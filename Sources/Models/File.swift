//
//  File.swift
//  Chameleon
//
//  Created by Ian Keen on 17/07/2016.
//
//

public struct File {
    let id: String
    let created: Int
    let name: String?
    let title: String
    let mimetype: String
    let filetype: String
    let pretty_type: String
    let user: User
    let mode: Mode
    let editable: Bool
    let is_external: Bool
    let is_public: Bool
    let external_type: String
    let username: String
    let size: Int
    
    let updated: Int?
    let editor: User?
    let last_editor: User?
    let state: String?

    let url_private: String
    let url_private_download: String
    let thumb_64: String?
    let thumb_80: String?
    let thumb_360: String?
    let thumb_360_gif: String?
    let thumb_360_w: Int?
    let thumb_360_h: Int?
    let thumb_480: String?
    let thumb_480_w: Int?
    let thumb_480_h: Int?
    let thumb_160: String?
    let permalink: String
    let permalink_public: String
    let edit_link: String?
    
    let preview: String?
    let preview_highlight: String?

    let lines: Int?
    let lines_more: Int?
    let public_url_shared: Bool
    let display_as_bot: Bool

    let channels: [Channel]
    let groups: [Group]
    let ims: [IM]
    
    let initial_comment: AnyObject?
    let num_stars: Int?
    let is_starred: Bool?
    let pinned_to: [Target]?
    
    let reactions: [Reaction]?
    let comments_count: Int
}

public extension File {
    public enum Mode: String {
        case hosted
        case external
        case snippet
        case post
    }
}
