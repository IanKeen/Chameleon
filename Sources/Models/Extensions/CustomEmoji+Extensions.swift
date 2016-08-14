
extension CustomEmoji: SlackEmoji {
    public var emojiSymbol: String {
        return ":\(self.name):"
    }
}
