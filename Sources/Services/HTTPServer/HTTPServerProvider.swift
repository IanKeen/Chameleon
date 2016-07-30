//
//  HTTPServerProvider.swift
//  Chameleon
//
//  Created by Ian Keen on 23/07/2016.
//
//

import Vapor

final public class HTTPServerProvider: HTTPServer {
    //MARK: - Private
    private let server: Droplet
    
    //MARK: - Lifecycle
    public init(server: Droplet) {
        self.server = server
    }
    
    //MARK: - Public
    public func start() {
        self.server.serve()
    }
    public func respond<T: AnyObject>(to method: HTTPRequest.Method, path: String, with object: T, function: WeakRouteHandler) {
//        self.server.add(method.clientMethod, path: path) { [weak object] request in
//            guard let object = object else { throw Abort.internalServerError }
//            
//            let headers = request.headers
//            let json = request.json ?? .null
//            return function(object)(headers, json)
//        }
    }
    public func respond(to method: HTTPRequest.Method, path: String, with handler: RouteHandler) {
//        self.server.add(method.clientMethod, path: path) { request in
//            let headers = request.headers
//            let json = request.json ?? .null
//            return handler(headers, json)
//        }
    }
}
