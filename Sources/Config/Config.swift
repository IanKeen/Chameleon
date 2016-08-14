
public enum ConfigError: Error, CustomStringConvertible {
    case missingRequiredParameter(param: String)
    case missingParameter(param: String)
    
    public var description: String {
        switch self {
        case .missingRequiredParameter(let parameter):
            return "Missing required parameter: '\(parameter)'"
        case .missingParameter(let parameter):
            return "Missing parameter: '\(parameter)'"
        }
    }
}

public final class Config {
    //MARK: - Private Properties
    private let supportedItems: [ConfigItem.Type]
    private let source: ConfigDataSource
    
    //MARK: - Lifecycle
    public init(supportedItems: [ConfigItem.Type], source: ConfigDataSource) throws {
        self.supportedItems = supportedItems
        self.source = source
    }
    
    //MARK: - Public Functions
    public func value<T: ConfigValue>(for item: ConfigItem.Type) throws -> T {
        let parameter = self.source.parameterModifier(item.name)
        
        if let userProvidedValue = self.source.value(for: parameter), !userProvidedValue.isEmpty {
            return try T.makeConfigValue(from: userProvidedValue)
            
        } else if let defaultValue = item.default {
            return try T.makeConfigValue(from: defaultValue)
            
        } else if item.required {
            throw ConfigError.missingRequiredParameter(param: parameter)
        }
        
        throw ConfigError.missingParameter(param: parameter)
    }
}
