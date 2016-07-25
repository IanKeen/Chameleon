//
//  URL+Linux.swift
//  Chameleon
//
//  Created by Ian Keen on 25/07/2016.
//
//

#if os(Linux)
    import Vapor
    
    public struct URL {
        private let uri: URI
        
        public init?(string: String) {
            do { self.uri = try URI(string) }
            catch { return nil }
        }
        
        public var absoluteString: String? { return self.uri.absoluteString }
    }
    
    extension URI {
        var absoluteString: String {
            /*
             foo://user:pass@example.com:8042/over/there?name=ferret#nose
             \_/   \_______/ \_________/ \__/ \________/ \_________/ \__/
             |         |          |       |        |          |       |
             scheme  userInfo    host    port     path      query   fragment
             */
            var result = ""
            if let scheme = self.scheme { result += "\(scheme)://" }
            if let userInfo = self.userInfo { result += "\(userInfo.username):\(userInfo.password)@" }
            if let host = self.host { result += host }
            if let port = self.port { result += ":\(port)" }
            if let path = self.path { result += (path.hasPrefix("/") ? "" : "/") + path }
            if let query = self.query { result += "?\(query)" }
            if let fragment = self.fragment { result += "#\(fragment)" }
            
            return result
        }
    }
#endif
