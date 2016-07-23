//
//  JSON+Parameters.swift
//  Chameleon
//
//  Created by Ian Keen on 22/07/2016.
//
//

extension JSON {
    func asParameters() -> [String: String] {
        guard let json = self.dictionary else { return [:] }
        return json.asParameters()
    }
}
extension Collection where Iterator.Element == (key: String, value: JSON) {
    func asParameters() -> [String: String] {
        var result = [String: String]()
        for (key, value) in self {
            guard let string = value.string else { continue }
            result[key] = string
        }
        return result
    }
}
extension Collection where Iterator.Element == (key: String, value: String) {
    func makeJSON() -> JSON {
        var result = [String: JSON]()
        for (key, value) in self {
            result[key] = .string(value)
        }
        return JSON.object(result)
    }
}

//TODO:
//MARK: remove when dependencies are cleared up
import Vapor
private extension JSON {
    var string: String? { return (self as Polymorphic).string }
}
