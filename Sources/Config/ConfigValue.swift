import Foundation
import Common

public enum ConfigValueError: Error, CustomStringConvertible {
    case unableToConvert(value: String, to: Any.Type)
    
    public var description: String {
        switch self {
        case .unableToConvert(let value, let to):
            return "Unable to convert value '\(value)' to type '\(String(to))'"
        }
    }
}


public protocol ConfigValue {
    static func makeConfigValue(from string: String) throws -> Self
}

extension String: ConfigValue {
    public static func makeConfigValue(from string: String) throws -> String {
        return string
    }
}
extension Int: ConfigValue {
    public static func makeConfigValue(from string: String) throws -> Int {
        guard let value = Int(string)
            else { throw ConfigValueError.unableToConvert(value: string, to: Int.self) }
        return value
    }
}
extension Double: ConfigValue {
    public static func makeConfigValue(from string: String) throws -> Double {
        guard let value = Double(string)
            else { throw ConfigValueError.unableToConvert(value: string, to: Double.self) }
        return value
    }
}
extension Float: ConfigValue {
    public static func makeConfigValue(from string: String) throws -> Float {
        guard let value = Float(string)
            else { throw ConfigValueError.unableToConvert(value: string, to: Float.self) }
        return value
    }
}
extension Bool: ConfigValue {
    public static func makeConfigValue(from string: String) throws -> Bool {
        return Bool(stringLiteral: string)
    }
}
extension Array: ConfigValue {
    public static func makeConfigValue(from string: String) throws -> [Element] {
        guard !string.isEmpty else { return [] }
        
        guard let type = Element.self as? ConfigValue.Type
            else { throw ConfigValueError.unableToConvert(value: string, to: [Element].self) }
        
        return try string
            .components(separatedBy: ",")
            .flatMap { try type.makeConfigValue(from: $0) as? Element }
    }
}
