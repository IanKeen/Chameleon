//
//  DefaultValueType.swift
//  Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

/// An abstraction the represents a type that can have a default value
public protocol DefaultValueType {
    /// The default value for this type
    static var defaultValue: Self { get }
}
extension Bool: DefaultValueType {
    public static var defaultValue: Bool { return false }
}
