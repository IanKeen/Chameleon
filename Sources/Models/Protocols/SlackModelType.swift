
/// An abstraction representing a buildable Slack model type
public protocol SlackModelType {
    /**
     Creates a Slack model from the provided `SlackModelBuilder`
     
     - parameter builder: The `SlackModelBuilder` that handles the `JSON` and other models
     - throws: A `KeyPathError`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new `SlackModelType`
     */
    static func makeModel(with builder: SlackModelBuilder) throws -> Self

    /**
     Creates a `[String: Any]` from the `SlackModelType`
     
     - returns: A new `[String: Any]` representation of the `SlackModelType`
     */
    func makeDictionary() -> [String: Any]
}

public extension Sequence where Iterator.Element: SlackModelType {
    /**
     Creates a `Sequence` of `[String: Any]`s from a `Sequence` of `SlackModelType`s
     
     - returns: A new `Sequence` of `[String: Any]`s representing the `SlackModelType`s
     */
    func makeArray() -> [[String: Any]] {
        return self.map { $0.makeDictionary() }
    }
}

/** 
 An abstraction representing a single value, used for defining how a value is output (if possible)
 when a model is being turned into a [String: Any]
 */
public protocol SlackModelValueType {
    var modelValue: Any? { get }
}
