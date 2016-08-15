@_exported import Foundation

#if os(Linux)
    public typealias URL = NSURL
    public typealias Data = NSData
#else
#endif
