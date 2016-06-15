//
//  OptionRepresentable.swift
//  Chameleon
//
//  Created by Ian Keen on 14/06/2016.
//
//

/// An abstraction representing an object that can be represented as a `String` key/value pair
protocol OptionRepresentable {
    var key: String { get }
    var value: String { get }
}

extension Sequence where Iterator.Element: OptionRepresentable {
    /**
     Creates a set of `[String: String]` parameters from a `Sequence` of `OptionRepresentable`s
     
     - returns: A `[String: String]` of parameters
     */
    func toParameters() -> [String: String] {
        var result = [String: String]()
        self.forEach { option in
            result[option.key] = option.value
        }
        return result
    }
}
