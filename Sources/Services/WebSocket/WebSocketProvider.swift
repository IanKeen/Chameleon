//
//  WebSocketProvider.swift
//  Chameleon
//
//  Created by Ian Keen on 3/06/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation
import WebSocketClient
import Jay

extension CloseCode: ErrorProtocol { }

/// Standard implementation of a WebSocketService
final public class WebSocketProvider: WebSocketService {
    //MARK: - Private Properties
    private var socket: WebSocket? {
        didSet {
            guard let socket = self.socket else { return }
            socket.onClose { self.onDisconnect?($0.code) }
            socket.onText { self.onText?($0) }
            socket.onBinary {
                let data = NSData(bytes: $0.bytes, length: $0.bytes.count)
                self.onData?(data)
            }
        }
    }
    private var client: Client? {
        willSet {
            guard let existing = self.socket else { return }
            _ = try? existing.close()
        }
    }
    
    //MARK: - Public
    public init() { }
    
    public var onConnect: (() -> Void)?
    public var onDisconnect: ((ErrorProtocol?) -> Void)?
    public var onText: ((String) -> Void)?
    public var onData: ((NSData) -> Void)?
    public var onError: ((ErrorProtocol) -> Void)?
    
    public func connect(url: String) throws {
        let uri: URI
        
        do { uri = try URI(url) }
        catch { throw WebSocketServiceError.invalidURL(url: url) }
        
        do {
            self.client = try Client(uri: uri) { [weak self] socket in
                guard let `self` = self else { return }
                
                self.socket = socket
                self.onConnect?()
            }
            
            try self.client?.connect(uri.description)
            
        } catch let error {
            throw WebSocketServiceError.internalError(error: error)
        }
    }
    public func disconnect() {
        _ = try? self.socket?.close()
    }
    public func send(json: JSON) {
        do {
            let data = try Jay(formatting: .prettified).dataFromJson(json)
            try self.socket?.send(try data.string())
            
        } catch let error {
            self.onError?(error)
        }
    }
    public func send(data: NSData) {
        do { try self.socket?.send(Data(pointer: UnsafePointer<Int8>(data.bytes), length: data.length)) }
        catch let error { self.onError?(error) }
    }
    public func send(string: String) {
        do { try self.socket?.send(string) }
        catch let error { self.onError?(error) }
    }
}
