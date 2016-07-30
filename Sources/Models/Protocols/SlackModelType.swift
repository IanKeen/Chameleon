//
//  SlackModelType.swift
//  Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

/// Represents an encapsulation error to build a nested chain of errors that can occur when attempting to build Slack models
public enum SlackModelTypeError<T: SlackModelType>: Error, CustomStringConvertible {
    /// A build error of type `T` and the nested error `error`
    case buildError(type: T.Type, error: Error)
    
    public var description: String {
        switch self {
        case .buildError(let type, let error):
            let nestedDescription = (error as? CustomStringConvertible)?.description ?? String(error)
            return "\(type): \(nestedDescription)"
        }
    }
}

/// An abstraction representing a buildable Slack model type
public protocol SlackModelType {
    /**
     Creates a Slack model from the provided `SlackModelBuilder`
     
     - parameter builder: The `SlackModelBuilder` that handles the `JSON` and other models
     - throws: A `KeyPathError`, `SlackModelError` or `SlackModelTypeError` with failure details
     - returns: A new `SlackModelType`
     */
    static func makeModel(with builder: SlackModelBuilder) throws -> Self

    /**
     Creates a `[String: Any]` from the `SlackModelType`
     
     - returns: A new `[String: Any]` representation of the `SlackModelType`
     */
    func makeDictionary() -> [String: Any]
}

/** 
 An abstraction representing a single value, used for defining how a value is output (if possible)
 when a model is being turned into a [String: Any]
 */
public protocol SlackModelValueType {
    var modelValue: Any? { get }
}

/**
 Encapsulates an attempt to build a Slack model object.
 By wrapping all attempts in this function we are able to accurately trace any
 nested errors to their source accurately.
 
 - parameter op: The closure containing the build attempt
 - throws: A `SlackModelTypeError` containing further details of the failure
 - returns: A new `SlackModelType` of type `T`
 */
public func tryMake<T: SlackModelType>(_ op: @autoclosure () throws -> T) throws -> T {
    do { return try op() }
    catch let error { throw SlackModelTypeError.buildError(type: T.self, error: error) }
}
