//
//  JSON+Conversion.swift
//  Chameleon
//
//  Created by Ian Keen on 28/07/2016.
//
//


//
// Provides the translation to/from Vapor data types and Swift standard types
//


import Vapor

//MARK: - Public
public extension JSON {
    public func makeDictionary() -> [String: Any]? {
        switch self {
        case .object(let dict):
            var result = [String: Any]()
            for (key, value) in dict {
                guard let value = value.asAny else { continue }
                result[key] = value
            }
            return result
            
        default: return nil
        }
    }
    
    public func makeArray() -> [Any]? {
        switch self {
        case .array(let array):
            return array.flatMap { $0.asAny }
            
        default: return nil
        }
    }
}

public extension Collection where Iterator.Element == (key: String, value: Any), Index == DictionaryIndex<String, Any> {
    public func makeJSONObject() -> JSON {
        var result = [String: JSON]()
        
        for (key, value) in self {
            if let value = value as? [[String: Any]] {
                result[key] = value.makeJSONObject()
                
            } else if let value = value as? [String: Any] {
                result[key] = value.makeJSONObject()
                
            } else {
                let value = _cast(value)
                switch value {
                case .null:
                    continue
                default:
                    result[key] = value
                }
            }
        }
        
        return JSON.object(result)
    }
}

public extension Sequence {
    public func makeJSONObject() -> JSON {
        let items = self.flatMap { value -> JSON? in
            if let value = value as? [Any] {
                return value.makeJSONObject()
                
            } else if let value = value as? [String: Any] {
                return value.makeJSONObject()
            }
            
            let value = _cast(value)
            switch value {
            case .null: return nil
            default: return value
            }
        }
        
        return JSON.array(items)
    }
}

public extension String {
    public func makeDictionary() throws -> [String: Any] {
        let data = Array(self.utf8)
        let json = try JSON(bytes: data)
        return json.makeDictionary() ?? [:]
    }
}

//MARK: - Private
private extension JSON {
    var asAny: Any? {
        switch self {
        case .null: return nil
        case .string(let value): return value
        case .bool(let value): return value
        case .number(let number):
            switch number {
            case .double(let value): return value
            case .integer(let value): return value
            }
        case .array(let value):
            return value.flatMap { $0.asAny }
        case .object(let dict):
            var result = [String: Any]()
            for (key, value) in dict {
                guard let value = value.asAny else { continue }
                result[key] = value
            }
            return result
        }
    }
}

////Private func pulled from Vapor.JSON
private func _cast(_ anyObject: Any) -> JSON {
    if let double = anyObject as? Double {
        if double == Double(Int(double)) {
            let int = Int(double)
            return .number(.integer(int))
        } else {
            return .number(.double(double))
        }
    }
    
    if let dict = anyObject as? [String: Any] {
        var object: [String: JSON] = [:]
        for (key, val) in dict {
            object[key] = _cast(val)
        }
        return .object(object)
    } else if let array = anyObject as? [Any] {
        return .array(array.map { _cast($0) })
    }
    
    if let int = anyObject as? Int {
        return .number(.integer(int))
    } else if let bool = anyObject as? Bool {
        return .bool(bool)
    }
    
    if let string = anyObject as? String {
        return .string(string)
    }
    
    return .null
}
