//
//  SlackModelBuilder+SlackModelType.swift
//  Chameleon
//
//  Created by Ian Keen on 27/07/2016.
//
//

//MARK: - SlackModelType Types
public extension SlackModelBuilder {
    /**
     Create a required `SlackModelType` from the `[String: Any]` using the supplied keypath
     
     - parameter keyPath: The keypath to the `[String: Any]` used to create the `SlackModelType`
     - throws: A `KeyPathError`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new `SlackModelType` object
     */
    public func model<T: SlackModelType>(_ keyPath: String) throws -> T {
        let json: [String: Any] = try self.json.keyPathValue(keyPath)
        
        let builder = SlackModelBuilder(
            json: json,
            users: self.users,
            channels: self.channels,
            groups: self.groups,
            ims: self.ims,
            team: self.team
        )
        return try T.makeModel(with: builder)
    }
    
    /**
     Create an optional `SlackModelType` from the `[String: Any]` using the supplied keypath
     
     If a `JSON` object is found at the keypath a regular throwable attempt is made to build
     the `SlackModelType` otherwise it returns nil
     
     - parameter keyPath: The keypath to the `[String: Any]` used to create the `SlackModelType`
     - throws: A `KeyPathError`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new `SlackModelType` object of type `T`, or nil
     */
    public func optionalModel<T: SlackModelType>(_ keyPath: String) throws -> T? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.model(keyPath) as T
    }
    
    /**
     Create a collection of required `SlackModelType`s from the `[String: Any]` using the supplied keypath
     
     - parameter keyPath: The keypath to the `[String: Any]` array used to create the `SlackModelType`s
     - throws: A `KeyPathError`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new sequence of `SlackModelType`s object
     */
    public func models<T: SlackModelType>(_ keyPath: String) throws -> [T] {
        let value: [[String: Any]] = try self.json.keyPathValue(keyPath)
        
        return try value.map { data in
            let builder = SlackModelBuilder(
                json: data,
                users: self.users,
                channels: self.channels,
                groups: self.groups,
                ims: self.ims,
                team: self.team
            )
            return try T.makeModel(with: builder)
        }
    }
    
    /**
     Create an optional collection of `SlackModelType`s from the `[String: Any]` using the supplied keypath
     
     If a `[String: Any]` array is found at the keypath a regular throwable attempt is made to build
     the `SlackModelType` sequence otherwise it returns nil
     
     - parameter keyPath: The keypath to the `[String: Any]` array used to create the `SlackModelType`s
     - throws: A `KeyPathError`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new sequence of `SlackModelType`s objects of type `T`, or nil
     */
    public func optionalModels<T: SlackModelType>(_ keyPath: String) throws -> [T]? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.models(keyPath) as [T]
    }
}
