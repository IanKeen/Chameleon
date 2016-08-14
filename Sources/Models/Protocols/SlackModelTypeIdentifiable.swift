
/// An abstraction representing a Slack model that can be identified by an id
public protocol SlackModelTypeIdentifiable {
    var id: String { get }
    
    func asUser() -> User?
    func asBotUser() -> BotUser?
    func asTeam() -> Team?
    func asChannel() -> Channel?
    func asGroup() -> Group?
    func asIM() -> IM?
}

public extension SlackModelTypeIdentifiable {
    public func asUser() -> User? { return nil }
    public func asBotUser() -> BotUser? { return nil }
    public func asTeam() -> Team? { return nil }
    public func asChannel() -> Channel? { return nil }
    public func asGroup() -> Group? { return nil }
    public func asIM() -> IM? { return nil }
}

extension User: SlackModelTypeIdentifiable {
    public func asUser() -> User? { return self }
}
extension BotUser: SlackModelTypeIdentifiable {
    public func asBotUser() -> BotUser? { return self }
}
extension Channel: SlackModelTypeIdentifiable {
    public func asChannel() -> Channel? { return self }
}
extension Team: SlackModelTypeIdentifiable {
    public func asTeam() -> Team? { return self }
}
extension Group: SlackModelTypeIdentifiable {
    public func asGroup() -> Group? { return self }
}
extension IM: SlackModelTypeIdentifiable {
    public func asIM() -> IM? { return self }
}
