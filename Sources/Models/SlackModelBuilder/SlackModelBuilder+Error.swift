//
//  SlackModelBuilder+Error.swift
//  Chameleon
//
//  Created by Ian Keen on 27/07/2016.
//
//

/// Describes a range of errors that can occur when attempting to build a model
public enum SlackModelError: Error, CustomStringConvertible {
    /// The requested type did not match the type of the found value
    case typeMismatch(keyPath: String, expected: String, got: String)
    
    /// The keypath used to lookup a value did not exist
    case slackModelLookup(keyPath: String)
    
    public var description: String {
        switch self {
        case .slackModelLookup(let keyPath):
            return "Unabled to lookup a SlackModel at the keyPath provided: \(keyPath)"
        case .typeMismatch(let keyPath, let expected, let got):
            return "Type mismatch on keyPath: '\(keyPath)' - Expected: \(expected), got: \(got)"
        }
    }
}
