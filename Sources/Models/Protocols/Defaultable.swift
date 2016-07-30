//
//  Defaultable.swift
//  Chameleon
//
//  Created by Ian Keen on 28/07/2016.
//
//

/// An abstraction the represents a type that can have a default value
public protocol Defaultable {
    /// The default value for this type
    static var defaultValue: Self { get }
}
extension Bool: Defaultable {
    public static var defaultValue: Bool { return false }
}
extension Int: Defaultable {
    public static var defaultValue: Int { return 0 }
}
extension String: Defaultable {
    public static var defaultValue: String { return "" }
}
