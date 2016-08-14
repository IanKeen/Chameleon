
/// An abstraction for an object that can be identified by a unique `id` and can use that `id` to compare equality
public protocol Identifiable: Equatable {
    /// The unique id for this object
    var id: String { get }
}

extension User: Identifiable { }
extension BotUser: Identifiable { }
extension Team: Identifiable { }
extension Channel: Identifiable { }
extension Group: Identifiable { }
extension IM: Identifiable { }

public func ==<T: Identifiable>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}
