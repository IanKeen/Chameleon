//
//  HTTPServerProvider.swift
//  Chameleon
//
//  Created by Ian Keen on 23/07/2016.
//
//

import Vapor
import HTTP
import Routing

final public class HTTPServerProvider: HTTPServer {
    //MARK: - Private
    private let server: Droplet
    
    //MARK: - Lifecycle
    public init(server: Droplet) {
        self.server = server
    }
    public convenience init() {
        self.init(server: Droplet())
    }
    
    //MARK: - Public
    public func start() {
        self.server.serve()
    }
    public func respond(to method: HTTPRequestMethod, at path: [String], with handler: RouteHandler) {
        self.server.addResponder(method.requestMethod, path) { request in
            let headers = request.headers
            let json = request.json ?? .null
            
            do {
                try handler(
                    headers: headers.makeDictionary(),
                    json: json.makeDictionary()
                )
                return Response(status: .ok)
                
            } catch { //let error {
                return Response(status: .internalServerError)
            }
        }
    }
    public func respond<T : AnyObject>(to method: HTTPRequestMethod, at path: [String], with object: T, _ function: (T) -> RouteHandler) {
        self.server.addResponder(method.requestMethod, path) { [weak object] request in
            guard let object = object else { return Response(status: .internalServerError) }
            
            let headers = request.headers
            let json = request.json ?? .null
            
            do {
                try function(object)(
                    headers: headers.makeDictionary(),
                    json: json.makeDictionary()
                )
                return Response(status: .ok)
                
            } catch { //let error {
                return Response(status: .internalServerError)
            }
        }
    }
}

extension Routing.RouteBuilder where Value == HTTP.Responder {
    public func addResponder(
        _ method: HTTP.Method,
        _ path: [String],
        _ value: (HTTP.Request) throws -> HTTP.ResponseRepresentable
        ) {
        add(
            path: ["*", method.description] + path,
            value: HTTP.Request.Handler({ request in
                return try value(request).makeResponse()
            })
        )
    }
}
