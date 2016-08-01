//
//  SlackBot+ServerAPI.swift
//  Chameleon
//
//  Created by Ian Keen on 30/07/2016.
//
//

import Services

public protocol SlackHTTPServer {
    func respond(to method: HTTPRequest.Method, path: String, with handler: RouteHandler)
    func respond<T: AnyObject>(to method: HTTPRequest.Method, path: String, with object: T, function: WeakRouteHandler)
}

public protocol SlackHTTPServerResponder: SlackService {
    func configure(server: SlackHTTPServer)
}


//here;

