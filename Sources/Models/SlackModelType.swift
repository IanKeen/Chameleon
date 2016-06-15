//
//  SlackModelType.swift
// Chameleon
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public enum SlackModelTypeError<T: SlackModelType>: ErrorProtocol {
    case BuildError(type: T.Type, error: ErrorProtocol)
}

public protocol SlackModelType {
    static func make(builder: SlackModelBuilder) throws -> Self
}

func tryMake<T: SlackModelType>(_ op: @autoclosure () throws -> T) throws -> T {
    do { return try op() }
    catch let error { throw SlackModelTypeError.BuildError(type: T.self, error: error) }
}
