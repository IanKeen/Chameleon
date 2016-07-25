////
////  EmojiList.swift
////  Chameleon
////
////  Created by Ian Keen on 6/06/2016.
////
////
//
//import Models
//import Services
//import Vapor
//
///// Handler for the `emoji.list` endpoint
//public struct EmojiList: WebAPIMethod {
//    public typealias SuccessParameters = ([CustomEmoji])
//    
//    //MARK: - Lifecycle
//    /**
//     Create a new `EmojiList` instance
//     
//     - returns: A new instance
//     */
//    public init() { }
//    
//    //MARK: - Public
//    public var networkRequest: HTTPRequest {
//        return HTTPRequest(
//            method: .get,
//            url: WebAPIURL("emoji.list")
//        )
//    }
//    public func handle(json: JSON, slackModels: SlackModels) throws -> SuccessParameters {
//        guard let emoji = json["emoji"]?.dictionary else { return [] }
//        
//        return emoji.flatMap { (key: String, value: JSON) -> CustomEmoji? in
//            guard
//                let string = stringFromPoly(value: value),
//                let alias = string.components(separatedBy: "alias:").last
//                else { return nil }
//            
//            let a = stringFromJson(value: emoji, key: alias)
//            let b = stringFromPoly(value: value)
//            
//            let imageUrl = a ?? b ?? ""
//            return CustomEmoji(name: key, imageUrl: imageUrl)
//        }
//    }
//    
//    
//    //MARK: - Temp
//    private func stringFromPoly(value: Polymorphic) -> String? {
//        return value.string
//    }
//    private func stringFromJson(value: [String: JSON], key: String) -> String? {
//        guard let json: Polymorphic = value[key] else { return nil }
//        return json.string
//    }
//}
