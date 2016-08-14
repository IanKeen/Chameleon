import Common

/// An abstraction representing an object capable being stored by a `Storage` object
public protocol StorableType {
    var stringValue: String { get }
    static func makeValue(from string: String) throws -> Self
}

extension String: StorableType {
    public var stringValue: String {
        return self
    }
    public static func makeValue(from string: String) throws -> String {
        return string
    }
}
extension Int: StorableType {
    public var stringValue: String {
        return String(self)
    }
    public static func makeValue(from string: String) throws -> Int {
        guard let value = Int(string) else { throw StorageError.invalidValue(value: string) }
        return value
    }
}
extension Bool: StorableType {
    public var stringValue: String {
        return self.stringValue
    }
    public static func makeValue(from string: String) throws -> Bool {
        return Bool(stringLiteral: string)
    }
}
extension Array: StorableType {
    public var stringValue: String {
        return self
            .flatMap { $0 as? StorableType }
            .map { $0.stringValue }
            .joined(separator: ",")
    }
    public static func makeValue(from string: String) throws -> [Element] {
        guard let type = Element.self as? StorableType.Type
            else { throw StorageError.unsupportedType(value: Element.self) }
        
        return try string
            .components(separatedBy: ",")
            .flatMap { try type.makeValue(from: $0) as? Element }
    }
}
