//
//  WebSocketProvider.swift
//  Chameleon
//
//  Created by Ian Keen on 3/06/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation
import Vapor
import VaporTLS
import HTTP
import URI
import Common

/// Standard implementation of a WebSocketService
final public class WebSocketProvider: WebSocketService {
    //MARK: - Private Properties
    private var socket: WebSocket? {
        willSet {
            _ = try? self.socket?.close()
        }
        didSet {
            guard let socket = self.socket else { return }
            socket.onClose = { _, code, reason, _ in
                self.onDisconnect?(WebSocketServiceError.genericError(reason: reason ?? "unknown"))
            }
            socket.onText = { _, text in
                self.onText?(text)
            }
            socket.onBinary = { _, bytes in
                self.onData?(Data(bytes: bytes))
            }
        }
    }
    
    //MARK: - Public
    public init() { }
    
    public var onConnect: (() -> Void)?
    public var onDisconnect: ((Error?) -> Void)?
    public var onText: ((String) -> Void)?
    public var onData: ((Data) -> Void)?
    public var onError: ((Error) -> Void)?
    
    public func connect(to url: String) throws {
        let uri: URI
        
        do { uri = try URI(url) }
        catch { throw WebSocketServiceError.invalidURL(url: url) }
        
        do {
            try WebSocket.connect(to: uri, using: Client<TLSClientStream>.self) { [weak self] socket in
                guard let `self` = self else { return }
                
                self.socket = socket
                self.onConnect?()
            }
            
        } catch let error {
            throw WebSocketServiceError.internalError(error: error)
        }
    }
    public func disconnect() {
        _ = try? self.socket?.close()
    }
    public func send(_ json: [String: Any]) {
        do {
            let data = try json.makeJSONObject().makeBytes().toString()
            try self.socket?.send(data)
            
        } catch let error {
            self.onError?(error)
        }
    }
    public func send(_ data: Data) {
        do { try self.socket?.send(try data.makeBytes()) }
        catch let error { self.onError?(error) }
    }
    public func send(_ string: String) {
        do { try self.socket?.send(string) }
        catch let error { self.onError?(error) }
    }
}
