#if !os(Linux)
    
import Foundation
    
public let DefaultConfigDataSource: ConfigDataSource = ProcessInfo.processInfo
    
extension ProcessInfo: ConfigDataSource {
    public var parameterModifier: (String) -> String {
        return { return "--\($0.lowerCamelCase)" }
    }
    public func value(for parameter: String) -> String? {
        return self.arguments.makeKeyValuePairs()[parameter]
    }
}
    
extension ConfigDataSource {
    static var fromProcessInfo: ConfigDataSource { return ProcessInfo.processInfo }
}

#endif
