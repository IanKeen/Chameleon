//
//  StringEncodable.swift
//  Chameleon
//
//  Created by Ian Keen on 29/07/2016.
//
//


//
// Provides the translation/encoding to/from Vapor data types and Swift standard types
//


import Common
import Models
import Vapor

//extension Collection where Iterator.Element == (key: String, value: Any) {
//    func makeEncodedParameters() -> [String: String] {
//        var result = [String: String]()
//        
//        for (key, value) in self {
//            guard let value = _string(input: value) else { continue }
//            result[key] = value
//        }
//        
//        return result
//    }
//}

extension Sequence {
    func makeEncodedParameters() -> String? {
        return _string(input: self)
    }
}


//Horrible casting function hooray!
private func _string(input: Any) -> String? {
    if let input = input as? SlackModelType {
        return try? input.makeDictionary().makeJSONObject().makeBytes().toString()
        
    } else if let input = input as? [SlackModelType] {
        let array = input.map { $0.makeDictionary().makeJSONObject() }
        return try? JSON.array(array).makeBytes().toString()
        
    } else if let input = input as? [JSON] {
        return try? JSON.array(input).makeBytes().toString()
        
    } else if let input = input as? [String: Any] {
        return try? input.makeJSONObject().makeBytes().toString()
        
    } else if let input = input as? JSON {
        return try? input.makeBytes().toString()
    }
    
    return String(input)
}
