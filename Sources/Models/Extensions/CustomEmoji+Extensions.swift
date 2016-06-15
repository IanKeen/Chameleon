//
//  CustomEmoji+Extensions.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

extension CustomEmoji: SlackEmoji {
    public var emojiSymbol: String {
        return ":\(self.name):"
    }
}
