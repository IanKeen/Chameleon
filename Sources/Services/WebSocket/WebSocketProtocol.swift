//
//  WebSocketProtocol.swift
//  Slack
//
//  Created by Ian Keen on 10/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation
import Jay

public enum WebSocketProtocolError: ErrorProtocol {
    case InvalidURL(String)
    case InvalidData(Any)
}

public protocol WebSocketProtocol: class {
    var onConnect: (() -> Void)? { get set }
    var onDisconnect: ((ErrorProtocol?) -> Void)? { get set }
    var onText: ((String) -> Void)? { get set }
    var onData: ((NSData) -> Void)? { get set }
    var onError: ((ErrorProtocol) -> Void)? { get set }
    
    func connect(url: String) throws
    func disconnect()
    
    func send(data: JSON)
    func send(data: NSData)
    func send(data: String)
}
