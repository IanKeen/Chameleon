
/// An abstraction for an object that can represent an emoji
public protocol SlackEmoji: SlackModelValueType {
    /// The string slack uses to identify this emoji
    var emojiSymbol: String { get }
}
extension SlackEmoji {
    public var modelValue: Any? {
        return self.emojiSymbol
    }
}
