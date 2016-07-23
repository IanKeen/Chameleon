//
//  SlackModelBuilder.swift
//  Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

/// Describes a range of errors that can occur when attempting to build a model
public enum SlackModelError: ErrorProtocol, CustomStringConvertible {
    /// The requested type did not match the type of the found value
    case typeMismatch(keyPath: String, expected: String, got: String)
    
    /// The keypath used to lookup a value did not exist
    case slackModelLookup(keyPath: String)
    
    public var description: String {
        switch self {
        case .slackModelLookup(let keyPath):
            return "Unabled to lookup a SlackModel at the keyPath provided: \(keyPath)"
        case .typeMismatch(let keyPath, let expected, let got):
            return "Type mismatch on keyPath: \(keyPath) - Expected: \(expected), got: \(got)"
        }
    }
}

/**
 *  Builds Slack models from `JSON` and completes object graphs from ids
 *
 *  Nested values can be looked up using keypaths such as "profile.bot_id"
 *
 *  Array lookups such as "profile.images[1]" are not currently supported
 *  (However they are not currently required for the Slack models)
 */
public struct SlackModelBuilder {
    private let json: JSON
    private let users: [User]
    private let channels: [Channel]
    private let groups: [Group]
    private let ims: [IM]
    
    /**
     Creates a new instance from the provided `JSON` using the supplied models to complete the objects graph via ids
     
     - parameter json:     The `JSON` used to build models
     - parameter users:    A sequence of `User`s used to find and populate any users in the graph via their id
     - parameter channels: A sequence of `Channel`s used to find and populate any channels in the graph via their id
     - parameter groups:   A sequence of `Group`s used to find and populate any groups in the graph via their id
     - parameter ims:      A sequence of `IM`s used to find and populate any ims in the graph via their id
     - returns: A new `SlackModelBuilder` instance
     */
    public init(json: JSON, users: [User], channels: [Channel], groups: [Group], ims: [IM]) {
        self.json = json
        self.users = users
        self.channels = channels
        self.groups = groups
        self.ims = ims
    }
}

//MARK: - Simple Types
extension SlackModelBuilder {
    /**
     Retrieve a required value from the `JSON` using the supplied keypath
     
     - parameter keyPath: The keypath used to find the value
     - throws: A `JSON.Error` with failure details
     - returns: The value at the keypath
     */
    public func property<T>(_ keyPath: String) throws -> T {
        return try self.json.keyPathValue(keyPath)
    }
    
    /**
     Retrieve an optional value from the `JSON` using the supplied keypath
     
     - parameter keyPath: The keypath used to find the value
     - returns: The value at keypath if found and it is of type `T`, otherwise nil
     */
    public func optionalProperty<T>(_ keyPath: String) -> T? {
        do { return try self.property(keyPath) }
        catch { return nil }
    }
}

//MARK: - Defaultable Types
extension SlackModelBuilder {
    /**
     Retrieve a value from the `JSON` using the supplied keypath or a default value
     
     - parameter keyPath: The keypath used to find the value
     - returns: The value at keypath if found and it is of type `T`, otherwise the default value
     */
    public func property<T: DefaultValueType>(_ keyPath: String) -> T {
        do { return try self.json.keyPathValue(keyPath) }
        catch { return T.defaultValue }
    }
}

//MARK: - RawRepresentable Types
extension SlackModelBuilder {
    /**
     Retrieve a required `RawRepresentable` value from the `JSON` using the supplied keypath
     
     - parameter keyPath: The keypath used to find the value
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: The value at the keypath
     */
    public func property<T: RawRepresentable>(_ keyPath: String) throws -> T {
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
     Retrieve an optional `RawRepresentable` value from the `JSON` using the supplied keypath
     
     - parameter keyPath: The keypath used to find the value
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: The value at keypath if found and it is of type `T`, otherwise nil
     */
    public func optionalProperty<T: RawRepresentable>(_ keyPath: String) throws -> T? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.property(keyPath) as T
    }
}

//MARK: - SlackModelType Types
extension SlackModelBuilder {
    /**
     Create a required `SlackModelType` from the `JSON` using the supplied keypath
     
     - parameter keyPath: The keypath to the `JSON` used to create the `SlackModelType`
     - throws: A `JSON.Error`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new `SlackModelType` object
     */
    public func property<T: SlackModelType>(_ keyPath: String) throws -> T {
        let json: [String: JSON] = try self.json.keyPathValue(keyPath)
        
        let builder = SlackModelBuilder(
            json: JSON.object(json),
            users: self.users,
            channels: self.channels,
            groups: self.groups,
            ims: self.ims
        )
        return try T.make(with: builder)
    }
    
    /**
     Create an optional `SlackModelType` from the `JSON` using the supplied keypath
     
     If a `JSON` object is found at the keypath a regular throwable attempt is made to build
     the `SlackModelType` otherwise it returns nil
     
     - parameter keyPath: The keypath to the `JSON` used to create the `SlackModelType`
     - throws: A `JSON.Error`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new `SlackModelType` object of type `T`, or nil
     */
    public func optionalProperty<T: SlackModelType>(_ keyPath: String) throws -> T? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.property(keyPath) as T
    }
    
    /**
     Create a collection of required `SlackModelType`s from the `JSON` using the supplied keypath
     
     - parameter keyPath: The keypath to the `JSON` array used to create the `SlackModelType`s
     - throws: A `JSON.Error`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new sequence of `SlackModelType`s object
     */
    public func collection<T: SlackModelType>(_ keyPath: String) throws -> [T] {
        let value: [JSON] = try self.json.keyPathValue(keyPath)
        
        return try value.map { data in
            let builder = SlackModelBuilder(
                json: data,
                users: self.users,
                channels: self.channels,
                groups: self.groups,
                ims: self.ims
            )
            return try T.make(with: builder)
        }
    }
    
    /**
     Create an optional collection of `SlackModelType`s from the `JSON` using the supplied keypath
     
     If a `JSON` array is found at the keypath a regular throwable attempt is made to build
     the `SlackModelType` sequence otherwise it returns nil
     
     - parameter keyPath: The keypath to the `JSON` array used to create the `SlackModelType`s
     - throws: A `JSON.Error`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new sequence of `SlackModelType`s objects of type `T`, or nil
     */
    public func optionalCollection<T: SlackModelType>(_ keyPath: String) throws -> [T]? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.collection(keyPath) as [T]
    }
}

//MARK: - Polymorphic SlackModelType Types
public typealias MakeFunction = (SlackModelBuilder) throws -> SlackModelType
extension SlackModelBuilder {
    /**
     Create a collection of required `SlackModelType`s from the `JSON` using the supplied keypath
     
     - parameter keyPath: The keypath to the `JSON` array used to create the `SlackModelType`s
     - parameter makeFunction: Allows "on-the-fly" selection of the `SlackModelType` that should be built
     - throws: A `JSON.Error`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new sequence of `SlackModelType`s object
     */
    public func collection<T>(_ keyPath: String, makeFunction: (JSON) -> MakeFunction) throws -> [T] {
        let value: [JSON] = try self.json.keyPathValue(keyPath)
        
        return try value.map { data in
            let builder = SlackModelBuilder(
                json: data,
                users: self.users,
                channels: self.channels,
                groups: self.groups,
                ims: self.ims
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
     Create an optional collection of `SlackModelType`s from the `JSON` using the supplied keypath
     
     If a `JSON` array is found at the keypath a regular throwable attempt is made to build
     the `SlackModelType` sequence otherwise it returns nil
     
     - parameter keyPath: The keypath to the `JSON` array used to create the `SlackModelType`s
     - parameter makeFunction: Allows "on-the-fly" selection of the `SlackModelType` that should be built
     - throws: A `JSON.Error`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new sequence of `SlackModelType`s objects of type `T`, or nil
     */
    public func optionalCollection<T>(_ keyPath: String, makeFunction: (JSON) -> MakeFunction) throws -> [T]? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.collection(keyPath, makeFunction: makeFunction)
    }
}

//MARK: - Pre-loaded Models
extension SlackModelBuilder {
    /**
     Retrieve the id of a required Slack model and return a matching complete model from the supplied objects
     
     - parameter keyPath: The keypath used to find the id
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: The Slack model of type `T` with the retrieved id
     */
    public func slackModel<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> T {
        let itemId: String = try self.property(keyPath)
        
        guard let item = self.identifiables().filter({ $0.id == itemId }).flatMap({ $0 as? T }).first
            else { throw SlackModelError.slackModelLookup(keyPath: keyPath) }
        
        return item
    }
    
    /**
     Retrieve the ids of a sequence of required Slack models and return matching complete models from the supplied objects
     
     - parameter keyPath: The keypath to the `JSON` array used to find the ids
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: The Slack models of type `T` with the retrieved ids
     */
    public func slackModels<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> [T] {
        let array: [JSON] = try self.property(keyPath)
        let itemIds = array.flatMap { $0.string }
        
        let items = self.identifiables().filter({ itemIds.contains($0.id) }).flatMap({ $0 as? T })
        guard items.count == itemIds.count else { throw SlackModelError.slackModelLookup(keyPath: keyPath) }
        
        return items
    }
    
    /**
     Retrieve the id of an optional Slack model and return a matching complete model from the supplied objects
     
     If an id is found at the keypath a regular throwable attempt is made to retrieve a Slack model
     otherwise it returns nil
     
     - parameter keyPath: The keypath used to find the id
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: The Slack model of type `T` with the retrieved id, or nil
     */
    public func optionalSlackModel<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> T? {
        if (!self.json.keyPathExists(keyPath, type: String.self, predicate: { !$0.isEmpty })) { return nil }
        return try self.slackModel(keyPath) as T
    }
    
    /**
     Retrieve the ids of an optional sequence of Slack models and return a matching complete models from the supplied objects
     
     If ids are found at the keypath a regular throwable attempt is made to retrieve the Slack models
     otherwise it returns nil
     
     - parameter keyPath: The keypath used to find the ids
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: A sequence of Slack models of type `T` with the retrieved ids, or nil
     */
    public func optionalSlackModels<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> [T]? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.slackModels(keyPath) as [T]
    }
}

//MARK: - Targets
extension SlackModelBuilder {
    /**
     Retrieve the id of a required Slack `Target` and return a matching complete model from the supplied objects
     
     - parameter keyPath: The keypath used to find the id
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: The `Target` with the retrieved id
     */
    public func slackModel(_ keyPath: String) throws -> Target {
        let itemId: String = try self.property(keyPath)
        
        guard let item = self.targets().filter({ $0.id == itemId }).first
            else { throw SlackModelError.slackModelLookup(keyPath: keyPath) }
        
        return item
    }
    
    /**
     Retrieve the ids of a sequence of required Slack `Target`s and return matching complete models from the supplied objects
     
     - parameter keyPath: The keypath to the `JSON` array used to find the ids
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: The sequence of `Target`s with the retrieved ids
     */
    public func slackModels(_ keyPath: String) throws -> [Target] {
        let array: [JSON] = try self.property(keyPath)
        let itemIds = array.flatMap { $0.string }
        
        let items = self.targets().filter({ itemIds.contains($0.id) })
        guard items.count == itemIds.count else { throw SlackModelError.slackModelLookup(keyPath: keyPath) }
        
        return items
    }
    
    /**
     Retrieve the id of an optional Slack `Target` and return a matching complete model from the supplied objects
     
     If an id is found at the keypath a regular throwable attempt is made to retrieve the `Target`
     otherwise it returns nil
     
     - parameter keyPath: The keypath used to find the id
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: The `Target` with the retrieved id, or nil
     */
    public func optionalSlackModel(_ keyPath: String) throws -> Target? {
        if (!self.json.keyPathExists(keyPath, type: String.self, predicate: { !$0.isEmpty })) { return nil }
        return try self.slackModel(keyPath)
    }
    
    /**
     Retrieve the ids of a sequence of optional Slack `Target`s and return matching complete models from the supplied objects
     
     If the ids are found at the keypath a regular throwable attempt is made to retrieve the `Target`s
     otherwise it returns nil
     
     - parameter keyPath: The keypath to the `JSON` array used to find the ids
     - throws: A `JSON.Error` or `SlackModelError` with failure details
     - returns: The sequence of `Target`s with the retrieved ids, or nil
     */
    public func optionalSlackModels(_ keyPath: String) throws -> [Target]? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.slackModels(keyPath)
    }
}

//MARK: - Helpers
extension SlackModelBuilder {
    //Not super stoked on this... but it does the job for now
    private func identifiables() -> [SlackModelTypeIdentifiable] {
        //combatting `Expression was too complex...`
        var items = [SlackModelTypeIdentifiable]()
        items.append(contentsOf: self.users.flatMap({ $0 as SlackModelTypeIdentifiable }))
        items.append(contentsOf: self.users.botUsers().flatMap({ $0 as SlackModelTypeIdentifiable }))
        items.append(contentsOf: self.channels.flatMap({ $0 as SlackModelTypeIdentifiable }))
        items.append(contentsOf: self.groups.flatMap({ $0 as SlackModelTypeIdentifiable }))
        items.append(contentsOf: self.ims.flatMap({ $0 as SlackModelTypeIdentifiable }))
        return items
    }
    private func targets() -> [Target] {
        return self.identifiables().flatMap { $0 as? Target }
    }
}

//TODO:
//MARK: remove when dependencies are cleared up
import Vapor
private extension JSON {
    var string: String? { return (self as Polymorphic).string }
}
