//NOTE: rather than a `String` hex value - it would be nice to use UIColor and have it generate the hex
//      obviously not available on linux, just adding this note for future thoughts on removing strings

public enum SlackColor: RawRepresentable, SlackModelValueType {
    public typealias RawValue = String
    
    case good, warning, danger
    case hex(value: String)
    
    public init?(rawValue: String) {
        if (rawValue == "good") {
            self = .good
        } else if (rawValue == "warning") {
            self = .warning
        } else if (rawValue == "danger") {
            self = .danger
        }
        self = .hex(value: rawValue)
    }
    public var rawValue: String {
        switch self {
        case .danger: return "danger"
        case .good: return "good"
        case .warning: return "warning"
        case .hex(let value): return value
        }
    }
}
