//
//  HTTPServer.swift
//  Chameleon
//
//  Created by Ian Keen on 23/07/2016.
//
//

//MARK: Typealiases
public typealias RouteHandler = (headers: [String: String], json: [String: Any]) -> Void
public typealias WeakRouteHandler = (AnyObject) -> (headers: [String: String], json: [String: Any]) -> Void

//MARK: - HTTPServer
public protocol HTTPServer {
    func start()
    func respond(to method: HTTPRequest.Method, path: String, with handler: RouteHandler)
    func respond<T: AnyObject>(to method: HTTPRequest.Method, path: String, with object: T, function: WeakRouteHandler)
}
