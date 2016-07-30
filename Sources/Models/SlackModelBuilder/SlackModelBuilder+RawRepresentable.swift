//
//  SlackModelBuilder+RawRepresentable.swift
//  Chameleon
//
//  Created by Ian Keen on 27/07/2016.
//
//

//MARK: - RawRepresentable Types
public extension SlackModelBuilder {
    /**
     Retrieve a required `RawRepresentable` value from the `[String: Any]` using the supplied keypath
     
     - parameter keyPath: The keypath used to find the value
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: The value at the keypath
     */
    public func `enum`<T: RawRepresentable>(_ keyPath: String) throws -> T {
        let value: T.RawValue? = try self.json.keyPathValue(keyPath)
        
        guard
            let result = value,
            let enumValue = T(rawValue: result)
            else {
                throw SlackModelError.typeMismatch(keyPath: keyPath, expected: String(T.self), got: String(value.dynamicType))
        }
        
        return enumValue
    }
    
    /**
     Retrieve an optional `RawRepresentable` value from the `[String: Any]` using the supplied keypath
     
     - parameter keyPath: The keypath used to find the value
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: The value at keypath if found and it is of type `T`, otherwise nil
     */
    public func optionalEnum<T: RawRepresentable>(_ keyPath: String) throws -> T? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.enum(keyPath) as T
    }
}
