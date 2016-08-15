import Foundation

extension ExpressibleByStringLiteral where StringLiteralType == String {
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

//extension URL: ExpressibleByStringLiteral {
//    public init(stringLiteral value: String) {
//        self = URL(string: value)!
//    }
//}

extension Bool: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let truthy = ["true", "yes", "y", "t", "1"]
        self = truthy.contains(value)
    }
}
