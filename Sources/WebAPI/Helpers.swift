//
// These are internal helpers used to convert between Vapor types and Swift standard types
//

import Models
import Foundation
import Common
import Core

extension SlackModelType {
    func makeEncodedObject() -> [String: String] {
        let dict = self.makeDictionary()
        
        var result = [String: String]()
        
        for (key, value) in dict {
            if let value = (value as? SlackModelType)?.makeDictionary().makeString() {
                result[key] = value
                
            } else if let value = (value as? EncodableType)?.encodedString {
                result[key] = value
            }
        }
        
        return result
    }
}

protocol EncodableType {
    var encodedString: String? { get }
}
extension EncodableType {
    var encodedString: String? { return String(self) }
}
extension String: EncodableType {
    var encodedString: String? {
        guard
            let bytes = try? percentEncoded(self.bytes),
            let encoded = String(data: Data(bytes: bytes), encoding: .utf8)
            else { return nil }
        
        return encoded
    }
}
extension Int: EncodableType { }
extension Double: EncodableType { }
extension Float: EncodableType { }
extension Bool: EncodableType { }
extension Array: EncodableType {
    var encodedString: String? {
        var items = [Any]()
        
        for item in self {
            if let item = (item as? EncodableType)?.encodedString {
                items.append(item)
                
            } else if let item = (item as? SlackModelType)?.makeDictionary().makeString() {
                items.append(item)
            }
        }
        
        guard
            let anyObject = items as? AnyObject,
            let data = try? JSONSerialization.data(withJSONObject: anyObject, options: []),
            let string = String(data: data, encoding: .utf8)
            else { return nil }
        
        return string.encodedString
    }
}
