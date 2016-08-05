//
//  Config.swift
//  Chameleon
//
//  Created by Ian Keen on 1/08/2016.
//
//

/// Describes a range of errors that can occur when build configuration data
public enum ConfigError: Error {
    /// A required parameter was not provided
    case missingRequiredParameter(parameter: String)
}

public final class Config {
    //MARK: - Private Properties
    private let supportedItems: [ConfigItem.Type] = [
        StorageURL.self,
        Token.self,
        ReconnectionAttempts.self,
        PingPongInterval.self,
        OAuthClientID.self,
        OAuthClientSecret.self
    ]
    private let input: ConfigInput
    private var values = [String: String]()
    
    //MARK: - Lifecycle
    public init(from input: ConfigInput) throws {
        self.input = input
        try self.validate()
    }
    
    //MARK: - Public Functions
    public func value<T: ConfigOutputType>(for param: String) -> T? {
        let modifiedParam = self.input.parameterModifier(param)
        
        guard let value = self.values[param] ?? self.values[modifiedParam]
            else { return nil }
        
        return T.makeValue(from: value)
    }
    
    //MARK: - Private Functions
    private func validate() throws {
        self.values = [:]
        let sets = self.supportedItems.makeSets()
        try sets.forEach(self.validateSet)
    }
    private func validateSet(set: [ConfigItem.Type]) throws {
        for item in set {
            let param = self.input.parameterModifier(item.variableName)
            
            if let value = (self.input.input[param] ?? item.default), !value.isEmpty {
                self.values[item.variableName] = value
                
            } else if (item.required) {
                throw ConfigError.missingRequiredParameter(parameter: param)
            }
        }
    }
}

