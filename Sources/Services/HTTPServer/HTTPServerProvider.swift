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
        self.server.add(methodFor(method), path: path) { [weak object] request in
            guard let object = object else { throw Abort.internalServerError }
            
            let headers = request.headers
            let json = request.json ?? .null
            return function(object)(headers, json)
        }
    }
    public func respond(to method: HTTPRequest.Method, path: String, with handler: RouteHandler) {
        self.server.add(methodFor(method), path: path) { request in
            let headers = request.headers
            let json = request.json ?? .null
            return handler(headers, json)
        }
    }
}

private func methodFor(_ method: HTTPRequest.Method) -> Method {
    switch method {
    case .get: return .get
    case .put: return .put
    case .post: return .post
    case .patch: return .patch
    case .delete: return .delete
    }
}
