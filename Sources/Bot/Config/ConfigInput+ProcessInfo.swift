//
//  ConfigInput+ProcessInfo.swift
//  Chameleon
//
//  Created by Ian Keen on 4/08/2016.
//
//

#if !os(Linux)
    
    import Foundation
    
    public let DefaultConfigInput: ConfigInput = ProcessInfo.processInfo
    
    extension ProcessInfo: ConfigInput {
        public var input: [String: String] {
            return self.arguments.dropFirst().makeConfigInput()
        }
        public var parameterModifier: (String) -> String {
            return { return "--\($0.lowerCamelCase)" }
        }
    }
    
#endif
