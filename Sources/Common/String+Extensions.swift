//
//  String+Extensions.swift
//  Chameleon
//
//  Created by Ian Keen on 16/06/2016.
//
//

public extension String {
    public var lowerCamelCase: String {
        return self
            .components(separatedBy: "_")
            .enumerated()
            .reduce("") { (result: String, item: (index: Int, part: String)) in
                return result + (item.index == 0 ? item.part.lowercased() : item.part.capitalized)
        }
    }
    public var snakeCase: String {
        return self
            .components(separatedBy: ["_", " "])
            .enumerated()
            .reduce("", { $0 + "_" + $1.1 })
    }
    public var screamingSnakeCase: String {
        return self.snakeCase.uppercased()
    }
}

extension String {
    func components(separatedBy separators: [String]) -> [String] {
        return separators.reduce([self]) { result, separator in
            return result.flatMap { $0.components(separatedBy: separator) }
        }
    }
}
