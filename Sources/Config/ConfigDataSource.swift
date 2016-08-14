
public protocol ConfigDataSource {
    var parameterModifier: (String) -> String { get }
    func value(for parameter: String) -> String?
}

extension Sequence where Iterator.Element == String {
    func makeKeyValuePairs() -> [String: String] {
        var result = [String: String]()
        for item in self {
            let items = item
                .characters
                .split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true)
                .map(String.init)
            
            guard
                items.count == 2,
                let key = items.first,
                let value = items.last
                else { continue }
            
            result[key] = value
        }
        return result
    }
}
