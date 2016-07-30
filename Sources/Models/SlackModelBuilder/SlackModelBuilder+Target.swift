//
//  SlackModelBuilder+Target.swift
//  Chameleon
//
//  Created by Ian Keen on 28/07/2016.
//
//

//MARK: - Targets
public extension SlackModelBuilder {
    /**
     Retrieve the id of a required Slack `Target` and return a matching complete model from the supplied objects
     
     - parameter keyPath: The keypath used to find the id
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: The `Target` with the retrieved id
     */
    public func target(_ keyPath: String) throws -> Target {
        let itemId: String = try self.property(keyPath)
        
        guard let item = self.targets().filter({ $0.id == itemId }).first
            else { throw SlackModelError.slackModelLookup(keyPath: keyPath) }
        
        return item
    }
    
    /**
     Retrieve the id of an optional Slack `Target` and return a matching complete model from the supplied objects
     
     If an id is found at the keypath a regular throwable attempt is made to retrieve the `Target`
     otherwise it returns nil
     
     - parameter keyPath: The keypath used to find the id
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: The `Target` with the retrieved id, or nil
     */
    public func optionalTarget(_ keyPath: String) throws -> Target? {
        if (!self.json.keyPathExists(keyPath, type: String.self, predicate: { !$0.isEmpty })) { return nil }
        return try self.target(keyPath)
    }
    
    /**
     Retrieve the ids of a sequence of required Slack `Target`s and return matching complete models from the supplied objects
     
     - parameter keyPath: The keypath to the `[String: Any]` array used to find the ids
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: The sequence of `Target`s with the retrieved ids
     */
    public func targets(_ keyPath: String) throws -> [Target] {
        let itemIds: [String] = try self.property(keyPath)
        
        let items = self.targets().filter({ itemIds.contains($0.id) })
        guard items.count == itemIds.count else { throw SlackModelError.slackModelLookup(keyPath: keyPath) }
        
        return items
    }
    
    /**
     Retrieve the ids of a sequence of optional Slack `Target`s and return matching complete models from the supplied objects
     
     If the ids are found at the keypath a regular throwable attempt is made to retrieve the `Target`s
     otherwise it returns nil
     
     - parameter keyPath: The keypath to the `[String: Any]` array used to find the ids
     - throws: A `KeyPathError` or `SlackModelError` with failure details
     - returns: The sequence of `Target`s with the retrieved ids, or nil
     */
    public func optionalTargets(_ keyPath: String) throws -> [Target]? {
        if (!self.json.keyPathExists(keyPath)) { return nil }
        return try self.targets(keyPath)
    }
}

