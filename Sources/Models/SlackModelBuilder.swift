//
//  SlackModelBuilder.swift
//  Slack
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Jay

public enum SlackModelError: ErrorProtocol {
    case TypeMismatch(keyPath: String, expected: String, got: String)
    case SlackModelLookup(keyPath: String)
}

public struct SlackModelBuilder {
    private let json: JSON
    private let users: [User]
    private let channels: [Channel]
    private let groups: [Group]
    private let ims: [IM]
    
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
    public func property<T>(_ keyPath: String) throws -> T {
        return try self.json.keyPathValue(keyPath)
    }
    public func optionalProperty<T>(_ keyPath: String) -> T? {
        return try? self.property(keyPath)
    }
}

//MARK: - Defaultable Types
extension SlackModelBuilder {
    public func property<T: DefaultValueType>(_ keyPath: String) -> T {
        return (try? self.json.keyPathValue(keyPath)) ?? T.defaultValue
    }
}

//MARK: - RawRepresentable Types 
extension SlackModelBuilder {
    public func property<T: RawRepresentable>(_ keyPath: String) throws -> T {
        let value: T.RawValue? = try self.json.keyPathValue(keyPath)
        
        guard
            let result = value,
            let enumValue = T(rawValue: result)
            else {
                throw SlackModelError.TypeMismatch(keyPath: keyPath, expected: String(T), got: String(value.dynamicType))
        }
        
        return enumValue
    }
    public func optionalProperty<T: RawRepresentable>(keyPath: String) throws -> T? {
        let value: T.RawValue? = try? self.json.keyPathValue(keyPath)
        guard value != nil else { return nil }
        
        return try self.property(keyPath) as T
    }
}

//MARK: - SlackModelType Types
extension SlackModelBuilder {
    public func property<T: SlackModelType>(_ keyPath: String) throws -> T {
        let builder = SlackModelBuilder(
            json: try self.json.keyPathValue(keyPath),
            users: self.users,
            channels: self.channels,
            groups: self.groups,
            ims: self.ims
        )
        return try T.make(builder: builder)
    }
    public func optionalProperty<T: SlackModelType>(_ keyPath: String) throws -> T? {
        let value: [String: Any]? = try? self.json.keyPathValue(keyPath)
        guard value != nil else { return nil }
        
        return try self.property(keyPath) as T
    }
    
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
            return try T.make(builder: builder)
        }
    }
    public func optionalCollection<T: SlackModelType>(_ keyPath: String) throws -> [T]? {
        let value: [[String: Any]]? = try? self.json.keyPathValue(keyPath)
        guard value != nil else { return nil }
        
        return try self.collection(keyPath) as [T]
    }
}

//MARK: - Pre-loaded Models
extension SlackModelBuilder {
    public func slackModel<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> T {
        let itemId: String = try self.property(keyPath)
        
        guard let item = self.identifiables().filter({ $0.id == itemId }).flatMap({ $0 as? T }).first
            else { throw SlackModelError.SlackModelLookup(keyPath: keyPath) }
        
        return item
    }
    public func slackModels<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> [T] {
        let itemIds: [String] = try self.property(keyPath)
        
        let items = self.identifiables().filter({ itemIds.contains($0.id) }).flatMap({ $0 as? T })
        guard items.count == itemIds.count else { throw SlackModelError.SlackModelLookup(keyPath: keyPath) }
        
        return items
    }
    
    public func optionalSlackModel<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> T? {
        let itemId: String? = try? self.property(keyPath)
        guard
            let unwrappedItemId = itemId
            where !unwrappedItemId.isEmpty
            else { return nil }
        
        return try self.slackModel(keyPath) as T
    }
    public func optionalSlackModels<T: SlackModelTypeIdentifiable>(_ keyPath: String) throws -> [T]? {
        let itemIds: [String]? = try? self.property(keyPath)
        guard itemIds != nil else { return nil }
        
        return try self.slackModels(keyPath) as [T]
    }
}

//MARK: - Targets
extension SlackModelBuilder {
    public func slackModel(_ keyPath: String) throws -> Target {
        let itemId: String = try self.property(keyPath)
        
        guard let item = self.targets().filter({ $0.id == itemId }).first
            else { throw SlackModelError.SlackModelLookup(keyPath: keyPath) }
        
        return item
    }
    public func slackModels(_ keyPath: String) throws -> [Target] {
        let itemIds: [String] = try self.property(keyPath)
        
        let items = self.targets().filter({ itemIds.contains($0.id) })
        guard items.count == itemIds.count else { throw SlackModelError.SlackModelLookup(keyPath: keyPath) }
        
        return items
    }
    
    public func optionalSlackModel(_ keyPath: String) throws -> Target? {
        let itemId: String? = try? self.property(keyPath)
        guard
            let unwrappedItemId = itemId
            where !unwrappedItemId.isEmpty
            else { return nil }
        
        return try self.slackModel(keyPath)
    }
    public func optionalSlackModels(_ keyPath: String) throws -> [Target]? {
        let itemIds: [String]? = try? self.property(keyPath)
        guard itemIds != nil else { return nil }
        
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
