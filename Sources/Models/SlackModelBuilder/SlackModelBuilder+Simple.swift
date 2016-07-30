//
//  SlackModelBuilder+Simple.swift
//  Chameleon
//
//  Created by Ian Keen on 27/07/2016.
//
//

//MARK: - Simple Types
public extension SlackModelBuilder {
    /**
     Retrieve a required value from the `[String: Any]` using the supplied keypath
     
     - parameter keyPath: The keypath used to find the value
     - throws: A `KeyPathError` with failure details
     - returns: The value at the keypath
     */
    public func property<T>(_ keyPath: String) throws -> T {
        return try self.json.keyPathValue(keyPath)
    }
    
    /**
     Retrieve an optional value from the `[String: Any]` using the supplied keypath
     
     - parameter keyPath: The keypath used to find the value
     - returns: The value at keypath if found and it is of type `T`, otherwise nil
     */
    public func optionalProperty<T>(_ keyPath: String) -> T? {
        do { return try self.property(keyPath) }
        catch { return nil }
    }
}
