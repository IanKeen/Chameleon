
/// An abstraction representing an object that can be represented as a `String` key/value pair
public protocol OptionRepresentable {
    var key: String { get }
    var value: String { get }
}

public extension Sequence where Iterator.Element: OptionRepresentable {
    /**
     Creates a set of `[String: String]` parameters from a `Sequence` of `OptionRepresentable`s
     
     - returns: A `[String: String]` of parameters
     */
    public func makeParameters() -> [String: String] {
        var result = [String: String]()
        self.forEach { option in
            result[option.key] = option.value
        }
        return result
    }
}
