//
//  String+Extensions.swift
//  Chameleon
//
//  Created by Ian Keen on 16/06/2016.
//
//

public extension String {
    public var snakeToLowerCamel: String {
        return self
            .components(separatedBy: "_")
            .enumerated()
            .reduce("") { (result: String, item: (index: Int, part: String)) in
                return result + (item.index == 0 ? item.part.lowercased() : item.part.capitalized)
            }
    }
}
