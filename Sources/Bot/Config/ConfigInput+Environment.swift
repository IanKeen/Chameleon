//
//  ConfigInput+Environment.swift
//  Chameleon
//
//  Created by Ian Keen on 4/08/2016.
//
//

#if os(Linux)
    
    import Environment
    
    public let DefaultConfigInput: ConfigInput = Environment()
    
    extension Environment: ConfigInput {
        public var input: [String: String] {
            return self.all()
        }
        public var parameterModifier: (String) -> String {
            return { return "--\($0.screamingSnakeCase)" }
        }
    }
    
#endif
