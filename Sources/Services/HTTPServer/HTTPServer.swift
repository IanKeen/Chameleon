//
//  HTTPServer.swift
//  Chameleon
//
//  Created by Ian Keen on 23/07/2016.
//
//

//MARK: Typealiases
public typealias RouteHandler = (headers: [String: String], json: [String: Any]?) throws -> Void

//MARK: - HTTPServer
public protocol HTTPServer {
    func start()
    
    func respond(
        to method: HTTPRequestMethod,
        at path: [String],
        with handler: RouteHandler
    )
    
    func respond<T: AnyObject>(
        to method: HTTPRequestMethod,
        at path: [String],
        with object: T,
        _ function: (T) -> RouteHandler
    )
}
