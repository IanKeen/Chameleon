//
//  ConfigInput.swift
//  Chameleon
//
//  Created by Ian Keen on 4/08/2016.
//
//

import Common

public protocol ConfigInput {
    var input: [String: String] { get }
    var parameterModifier: (String) -> String { get }
}

extension Sequence where Iterator.Element == String {
    func makeConfigInput() -> [String: String] {
        var result = [String: String]()
        for item in self {
            let items = item.components(separatedBy: "=")
            
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
