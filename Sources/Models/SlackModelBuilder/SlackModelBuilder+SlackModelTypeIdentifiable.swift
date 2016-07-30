//
//  SlackModelBuilder+SlackModelTypeIdentifiable.swift
//  Chameleon
//
//  Created by Ian Keen on 27/07/2016.
//
//

//MARK: - Pre-loaded Models
public extension SlackModelBuilder {
    /**
     Retrieve the id of a required Slack model and return a matching complete model from the supplied objects
     
     - parameter keyPath: The keypath used to find the id
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: The Slack model of type `T` with the retrieved id
     */
    public func lookup<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> T {
        let itemId: String = try self.property(keyPath)
        
        guard let item = self.identifiables().filter({ $0.id == itemId }).flatMap({ $0 as? T }).first
            else { throw SlackModelError.slackModelLookup(keyPath: keyPath) }
        
        return item
    }
    
    /**
     Retrieve the id of an optional Slack model and return a matching complete model from the supplied objects
     
     If an id is found at the keypath a regular throwable attempt is made to retrieve a Slack model
     otherwise it returns nil
     
     - parameter keyPath: The keypath used to find the id
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: The Slack model of type `T` with the retrieved id, or nil
     */
    public func optionalLookup<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> T? {
        if (!self.json.keyPathExists(keyPath, type: String.self, predicate: { !$0.isEmpty })) { return nil }
        return try self.lookup(keyPath) as T
    }
    
    /**
     Retrieve the ids of a sequence of required Slack models and return matching complete models from the supplied objects
     
     - parameter keyPath: The keypath to the `[String: Any]` array used to find the ids
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: The Slack models of type `T` with the retrieved ids
     */
    public func lookup<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> [T] {
        let itemIds: [String] = try self.property(keyPath)
        
        let items = self.identifiables().filter({ itemIds.contains($0.id) }).flatMap({ $0 as? T })
        guard items.count == itemIds.count else { throw SlackModelError.slackModelLookup(keyPath: keyPath) }
        
        return items
    }
    
    /**
     Retrieve the ids of an optional sequence of Slack models and return a matching complete models from the supplied objects
     
     If ids are found at the keypath a regular throwable attempt is made to retrieve the Slack models
     otherwise it returns nil
     
     - parameter keyPath: The keypath used to find the ids
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: A sequence of Slack models of type `T` with the retrieved ids, or nil
     */
    public func optionalLookup<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> [T]? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.lookup(keyPath) as [T]
    }
}

