//
//  ConfigOutputType.swift
//  Chameleon
//
//  Created by Ian Keen on 4/08/2016.
//
//

public protocol ConfigOutputType {
    static func makeValue(from string: String) -> Self?
}

extension String: ConfigOutputType {
    public static func makeValue(from string: String) -> String? {
        return string
    }
}
extension Int: ConfigOutputType {
    public static func makeValue(from string: String) -> Int? {
        return Int(string)
    }
}
extension Double: ConfigOutputType {
    public static func makeValue(from string: String) -> Double? {
        return Double(string)
    }
}
extension Bool: ConfigOutputType {
    public static func makeValue(from string: String) -> Bool? {
        return Bool(string)
    }
}
extension Array where Element: ConfigOutputType {
    public static func makeValue(from string: String) -> [Element]? {
        return string
            .components(separatedBy: ",")
            .flatMap { Element.makeValue(from: $0) }
    }
}
