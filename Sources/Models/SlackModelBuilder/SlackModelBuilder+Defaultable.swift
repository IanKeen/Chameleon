//
//  SlackModelBuilder+Defaultable.swift
//  Chameleon
//
//  Created by Ian Keen on 27/07/2016.
//
//

//MARK: - Defaultable Types
public extension SlackModelBuilder {
    /**
     Retrieve a value from the `[String: Any]` using the supplied keypath or a default value
     
     - parameter default: The keypath used to find the value
     - returns: The value at keypath if found and it is of type `T`, otherwise the default value
     */
    public func `default`<T: Defaultable>(_ keyPath: String) -> T {
        do { return try self.json.keyPathValue(keyPath) }
        catch { return T.defaultValue }
    }
}
