//
//  SlackModelType.swift
//  Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

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
