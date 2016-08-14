
extension Emoji: SlackEmoji {
    public var emojiSymbol: String {
        return ":\(self.rawValue):"
    }
}
