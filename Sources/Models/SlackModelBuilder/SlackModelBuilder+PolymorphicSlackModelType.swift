//
//  SlackModelBuilder+PolymorphicSlackModelType.swift
//  Chameleon
//
//  Created by Ian Keen on 27/07/2016.
//
//

public typealias MakeFunction = (SlackModelBuilder) throws -> SlackModelType

//MARK: - Polymorphic SlackModelType Types
public extension SlackModelBuilder {
    /**
     Create a collection of required `SlackModelType`s from the `[String: Any]` using the supplied keypath
     
     - parameter keyPath: The keypath to the `[String: Any]` array used to create the `SlackModelType`s
     - parameter makeFunction: Allows "on-the-fly" selection of the `SlackModelType` that should be built
     - throws: A `KeyPathError`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new sequence of `SlackModelType`s object
     */
    public func models<T>(_ keyPath: String, makeFunction: ([String: Any]) -> MakeFunction) throws -> [T] {
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
            
            let maker = makeFunction(data)
            let instance = try maker(builder)
            guard let result = instance as? T else {
                throw SlackModelError.typeMismatch(keyPath: keyPath, expected: String(T.self), got: String(instance.self))
            }
            return result
        }
    }
    
    /**
     Create an optional collection of `SlackModelType`s from the `[String: Any]` using the supplied keypath
     
     If a `[String: Any]` array is found at the keypath a regular throwable attempt is made to build
     the `SlackModelType` sequence otherwise it returns nil
     
     - parameter keyPath: The keypath to the `[String: Any]` array used to create the `SlackModelType`s
     - parameter makeFunction: Allows "on-the-fly" selection of the `SlackModelType` that should be built
     - throws: A `KeyPathError`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new sequence of `SlackModelType`s objects of type `T`, or nil
     */
    public func optionalModels<T>(_ keyPath: String, makeFunction: ([String: Any]) -> MakeFunction) throws -> [T]? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.models(keyPath, makeFunction: makeFunction)
    }
}
