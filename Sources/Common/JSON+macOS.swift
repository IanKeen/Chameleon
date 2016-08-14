//TODO: remove?

//
//#if !os(Linux)
//private protocol JSONAdjustable {
//    var anyValue: Any? { get }
//}
//
//import Foundation
//
//extension NSDictionary: JSONAdjustable {
//    private var anyValue: Any? {
//        var result = [String: Any]()
//        for (key, value) in self {
//            guard let key = key as? String else { continue }
//            if let value = value as? JSONAdjustable {
//                result[key] = value.anyValue
//            }
//            result[key] = value as Any
//        }
//        return result
//    }
//}
//extension NSArray: JSONAdjustable {
//    private var anyValue: Any? {
//        var result = [Any]()
//        for value in self {
//            if let value = value as? JSONAdjustable {
//                result.append(value.anyValue)
//            }
//            result.append(value as Any)
//        }
//        return result
//    }
//}
//#endif
//
//
////public func sanitisedDictionary(input: Any) -> [String: Any]? {
////    if let input = input as? [String: Any] {
////        return input
////    }
////    guard let input = input as? [String: AnyObject] else { return nil }
////    
////    var result = [String: Any]()
////    for (key, value) in input {
////        if let value = value as? JSONAdjustable {
////            result[key] = value.anyValue
////        }
////        result[key] = value as Any
////    }
////    return result
////}
