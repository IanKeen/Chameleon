//
//  JSON+Conversions.swift
//  Chameleon
//
//  Created by Ian Keen on 21/07/2016.
//
//
//
//public extension Collection where Iterator.Element == (key: String, value: Any) {
//    public func makeJSON() -> JSON {
//        var result = [String: JSON]()
//        for (key, value) in self {
//            if let value = value as? JSONRepresentable {
//                result[key] = value.makeJSON()
//            }
//        }
//        return JSON.object(result)
//    }
//}
