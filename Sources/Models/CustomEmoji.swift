//
//  CustomEmoji.swift
//  Slack
//
//  Created by Ian Keen on 6/06/2016.
//
//

public struct CustomEmoji {
    public let name: String
    public let imageUrl: String
    
    public init(name: String, imageUrl: String) {
        self.name = name
        self.imageUrl = imageUrl
    }
}

extension CustomEmoji: SlackEmoji {
    public var emojiSymbol: String {
        return ":\(self.name):"
    }
}
