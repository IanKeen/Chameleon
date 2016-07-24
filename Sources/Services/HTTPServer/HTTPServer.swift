//
//  HTTPServer.swift
//  Chameleon
//
//  Created by Ian Keen on 23/07/2016.
//
//

//MARK: Typealiases
public typealias RouteHandler = (Headers, JSON) -> HTTPResponse
public typealias WeakRouteHandler = (AnyObject) -> (Headers, JSON) -> HTTPResponse

//MARK: - HTTPServer
public protocol HTTPServer {
    func start()
    func respond(to method: HTTPRequest.Method, path: String, with handler: RouteHandler)
    func respond<T: AnyObject>(to method: HTTPRequest.Method, path: String, with object: T, function: WeakRouteHandler)
}
