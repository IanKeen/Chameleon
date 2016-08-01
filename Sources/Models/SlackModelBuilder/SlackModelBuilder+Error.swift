//
//  SlackModelBuilder+Error.swift
//  Chameleon
//
//  Created by Ian Keen on 27/07/2016.
//
//

/// Represents an encapsulation error to build a nested chain of errors that can occur when attempting to build Slack models
public enum SlackModelBuilderError<T: SlackModelType>: Error, CustomStringConvertible {
    /// A build error of type `T` and the nested error `error`
    case buildError(type: T.Type, builder: SlackModelBuilder, error: Error)
    
    public var description: String {
        switch self {
        case .buildError(let type, let builder, let error):
            let nestedDescription = (error as? CustomStringConvertible)?.description ?? String(error)
            return "\(type): \(nestedDescription)\nData: \(builder.json)"
        }
    }
}

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

/**
 Encapsulates an attempt to build a Slack model object.
 By wrapping all attempts in this function we are able to accurately trace any
 nested errors to their source accurately.

 - parameter builder: The `SlackModelBuilder` being used to build the `SlackModelType`
 - parameter op: The closure containing the build attempt
 - throws: A `SlackModelTypeError` containing further details of the failure
 - returns: A new `SlackModelType` of type `T`
 */
public func tryMake<T: SlackModelType>(_ builder: SlackModelBuilder, _ op: @autoclosure () throws -> T) throws -> T {
    do { return try op() }
    catch let error { throw SlackModelBuilderError.buildError(type: T.self, builder: builder, error: error) }
}
