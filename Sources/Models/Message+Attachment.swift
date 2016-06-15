//
//  Message+Attachment.swift
//  Chameleon
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

extension Message {
    public struct Attachment {
        public let fallback: String
        public let color: String?
        public let pretext: String?
        
        public let author_name: String?
        public let author_link: String?
        public let author_icon: String?
        
        public let title: String?
        public let title_link: String?
        
        public let text: String
        
        public let fields: [Field]?
        
        public let from_url: String?
        public let image_url: String?
        public let thumb_url: String?
    }
}

extension Message.Attachment {
    public struct Field {
        public let title: String
        public let value: String
        public let short: Bool
    }
}
