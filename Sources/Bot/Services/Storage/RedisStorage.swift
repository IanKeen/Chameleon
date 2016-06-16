//
//  RedisStorage.swift
//  Chameleon
//
//  Created by Ian Keen on 15/06/2016.
//
//

import Redbird

/// Provides Redis based storage of key/value pairs
public final class RedisStorage: Storage {
    //MARKL - Private
    private let client: Redbird
    
    //MARK: - Public
    public init(address: String, port: UInt16, password: String?) throws {
        let config = RedbirdConfig(address: address, port: port, password: password)
        self.client = try Redbird(config: config)
    }
    
    //MARK: - Storage
    public func set<T: StorableType>(type: T.Type, in: StorageNamespace, key: String, value: T) throws {
        guard let value = value as? RedisStorable else { throw StorageError.unsupportedType(value: T.self) }
        let key = "\(`in`.namespace):\(key)"
        do {
            try self.client.command("DEL", params: [key])
            try self.client.command(value.redisStoreCommand, params: [key] + value.redisStoreParams)
        }
        catch let error { throw StorageError.internalError(error: error) }
    }
    public func get<T: StorableType>(type: T.Type, in: StorageNamespace, key: String) -> T? {
        guard let type = type as? RedisRetrievable.Type else { print("Unsupported data type: \(T.self)"); return nil }
        let key = "\(`in`.namespace):\(key)"
        do {
            let result = try self.client.command(type.redisRetrieveCommand, params: [key])
            guard let stringValue = try result.toMaybeString() else { return nil }
            return type.redisValue(from: stringValue) as? T
        }
        catch let error { print("\(error)"); return nil }
    }
}

//MARK: - Redis Serialization
protocol RedisStorable {
    var redisStoreCommand: String { get }
    var redisStoreParams: [String] { get }
}
extension RedisStorable {
    var redisStoreCommand: String { return "SET" }
    var redisStoreParams: [String] { return [String(self)] }
}

//MARK: - Redis Deserialization
protocol RedisRetrievable {
    static var redisRetrieveCommand: String { get }
    static func redisValue(from: String) -> Self?
}
extension RedisRetrievable {
    static var redisRetrieveCommand: String { return "GET" }
}

//MARK: - RedisStorable/RedisRetrievable Implementations
extension String: RedisStorable, RedisRetrievable {
    static func redisValue(from: String) -> String? { return from }
}
extension Int: RedisStorable, RedisRetrievable {
    var redisStoreParams: [String] { return [ String(self)] }
    static func redisValue(from: String) -> Int? { return Int(from) }
}
extension Bool: RedisStorable, RedisRetrievable {
    static func redisValue(from: String) -> Bool? {
        return (from == "true" ? true : false)
    }
}

// I think these are wrong... need to test!!
extension Sequence where Iterator.Element: RedisStorable {
    var redisStoreCommand: String { return "LPUSH" }
    var redisStoreParams: [String] {
        return [self
            .flatMap { $0.redisStoreParams }
            .joined(separator: ";")]
    }
}
extension Sequence where Iterator.Element: RedisRetrievable {
    var redisRetrieveCommand: String { return "MGET" }
    static func redisValue(from: String) -> Self? {
        return from.components(separatedBy: ";") as? Self
    }
}
