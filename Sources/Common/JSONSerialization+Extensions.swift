import Foundation

public extension JSONSerialization {
    public static func jsonObject(with data: Data) throws -> [String: Any]? {
        #if os(Linux)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        #else
            guard let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return nil }
            let input = result.map { key, value -> (String, Any) in
                return (key, value as Any)
            }
            return Dictionary<String, Any>(input)
        #endif
    }
}
