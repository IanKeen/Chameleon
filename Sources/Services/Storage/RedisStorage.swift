//import Redbird
//import Foundation
//import Common
//
///// Provides Redis based storage of key/value pairs
//public final class RedisStorage: Storage {
//    //MARKL - Private
//    private let client: Redbird
//    
//    //MARK: - Public
//    public convenience init(url urlString: String) throws {
//        guard let url = URL(string: urlString) else { throw StorageError.invalidURL(url: urlString) }
//        
//        guard
//            let host = url.host,
//            let port = (url as NSURL).port?.uint16Value,
//            let password = url.password
//            else { throw StorageError.invalidURL(url: urlString) }
//        
//        try self.init(address: host, port: port, password: password)
//    }
//    public required init(address: String, port: UInt16, password: String?) throws {
//        let config = RedbirdConfig(address: address, port: port, password: password)
//        self.client = try Redbird(config: config)
//    }
//    
//    //MARK: - Storage
//    public func set<T: StorableType>(_ type: T.Type, in: StorageNamespace, key: String, value: T) throws {
//        let key = "\(`in`.namespace):\(key)"
//        do {
//            try self.client.command("DEL", params: [key])
//            try self.client.command("SET", params: [key] + [value.stringValue])
//        }
//        catch let error { throw StorageError.internalError(error: error) }
//    }
//    public func get<T: StorableType>(_ type: T.Type, in: StorageNamespace, key: String) -> T? {
//        let key = "\(`in`.namespace):\(key)"
//        do {
//            let result = try self.client.command("GET", params: [key])
//            guard let stringValue = try result.toMaybeString() else { return nil }
//            return try T.makeValue(from: stringValue)
//        }
//        catch let error { print("\(error)"); return nil }
//    }
//}
