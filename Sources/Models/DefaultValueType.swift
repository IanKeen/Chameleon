//
//  DefaultValueType.swift
// Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public protocol DefaultValueType {
    static var defaultValue: Self { get }
}
extension Bool: DefaultValueType {
    public static var defaultValue: Bool { return false }
}
