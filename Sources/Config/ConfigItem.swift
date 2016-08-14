public protocol ConfigItem {
    static var name: String { get }
    static var description: String { get }
    static var required: Bool { get }
    static var `default`: String? { get }
}
extension ConfigItem {
    public static var required: Bool { return false }
    public static var `default`: String? { return nil }
}
