
public extension String {
    public func makeQueryParameters() -> [String: String] {
        let pairs = self
            .components(separatedBy: "&")
            .flatMap { string -> (String, String)? in
                let pair = string.components(separatedBy: "=")
                guard pair.count == 2 else { return nil }
                return (pair.first!, pair.last!)
        }
        return Dictionary<String, String>(pairs)
    }
}
