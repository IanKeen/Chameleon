public protocol CancellableDispatchOperation {
    func cancel() throws
}

#if os(Linux)

import Strand

extension Strand: CancellableDispatchOperation { }
    
public func inBackground(function: () -> Void) -> CancellableDispatchOperation {
    return try! Strand(closure: function)
}
public func inBackground(try function: () throws -> Void, catch failure: (Error) -> Void) -> CancellableDispatchOperation {
    let item = {
        do {
            try function()
        } catch let error {
            failure(error)
        }
    }
    return try! Strand(closure: item)
}

#else

import Foundation

extension DispatchWorkItem: CancellableDispatchOperation { }
    
let backgroundQueue = DispatchQueue.global()
    
public func inBackground(function: () -> Void) -> CancellableDispatchOperation {
    let item = DispatchWorkItem(block: function)
    backgroundQueue.async(execute: item)
    return item
}
public func inBackground(try function: () throws -> Void, catch failure: (Error) -> Void) -> CancellableDispatchOperation {
    let item = DispatchWorkItem {
        do {
            try function()
        } catch let error {
            failure(error)
        }
    }
    backgroundQueue.async(execute: item)
    return item
}

#endif
