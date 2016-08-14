#if os(Linux)
    
import Environment

public let DefaultConfigDataSource: ConfigDataSource = Environment()
    
extension Environment: ConfigDataSource {
    public var parameterModifier: (String) -> String {
        return { return $0.screamingSnakeCase }
    }
    public func value(for parameter: String) -> String? {
        return self.all()[parameter]
    }
}

extension ConfigDataSource {
    static var fromEnvironment: ConfigDataSource { return Environment() }
}

#endif
