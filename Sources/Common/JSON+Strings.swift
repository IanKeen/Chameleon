//
//  JSON+Strings.swift
//  Chameleon
//
//  Created by Ian Keen on 13/06/2016.
//
//

import Vapor

extension JSON {
    /// Provides a string representation of the type
    public var jsonTypeDescription: String {
        return String(self)
    }
    
    /// Provides a string representation of the value
    public var jsonValueDescription: String {
        switch self {
        case .null:
            return "null"
        case .boolean(let value):
            return (value ? "true" : "false")
        case .number(let number):
            switch number {
            case .double(let value):
                return "\(value)"
            case .integer(let value):
                return "\(value)"
            case .unsignedInteger(let value):
                return "\(value)"
            }
        case .string(let value):
            return value
            
        case .array(let value):
            let items = value
                .map { $0.jsonValueDescription }
                .joined(separator: ",")
            return "[\(items)]"
            
        case .object(let value):
            let items = value
                .map { key, value in
                    return "\(key): \(value.jsonValueDescription)"
                }
                .joined(separator: ",")
            return "{\(items)}"
        }
    }
}
