
public struct File {
    public let id: String
    public let created: Int?
    public let name: String?
    public let title: String?
    public let mimetype: String?
    public let filetype: String?
    public let pretty_type: String?
    public let user: User?
    public let mode: Mode?
    public let editable: Bool
    public let is_external: Bool
    public let is_public: Bool
    public let external_type: String?
    public let username: String?
    public let size: Int?
    
    public let updated: Int?
    public let editor: User?
    public let last_editor: User?
    public let state: String?

    public let url_private: String?
    public let url_private_download: String?
    public let thumb_64: String?
    public let thumb_80: String?
    public let thumb_360: String?
    public let thumb_360_gif: String?
    public let thumb_360_w: Int?
    public let thumb_360_h: Int?
    public let thumb_480: String?
    public let thumb_480_w: Int?
    public let thumb_480_h: Int?
    public let thumb_160: String?
    public let permalink: String?
    public let permalink_public: String?
    public let edit_link: String?
    
    public let preview: String?
    public let preview_highlight: String?

    public let lines: Int?
    public let lines_more: Int?
    public let public_url_shared: Bool
    public let display_as_bot: Bool

    public let channels: [Channel]?
    public let groups: [Group]?
    public let ims: [IM]?
    
    public let initial_comment: Any? //TODO
    public let num_stars: Int?
    public let is_starred: Bool?
    public let pinned_to: [Target]?
    
    public let reactions: [Reaction]?
    public let comments_count: Int?
}

public extension File {
    public enum Mode: String, SlackModelValueType {
        case hosted
        case external
        case snippet
        case post
    }
}
