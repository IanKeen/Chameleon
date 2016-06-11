//
//  Message+SubType.swift
//  Slack
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public extension Message {
    public enum SubType: String {
        case bot_message
        case me_message
        case message_changed
        case message_deleted
        case channel_join
        case channel_leave
        case channel_topic
        case channel_purpose
        case channel_name
        case channel_archive
        case channel_unarchive
        case group_join
        case group_leave
        case group_topic
        case group_purpose
        case group_name
        case group_archive
        case group_unarchive
        case file_share
        case file_comment
        case file_mention
        case pinned_item
        case unpinned_item
    }
}
