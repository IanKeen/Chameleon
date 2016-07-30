////
////  Int+Random.swift
////  Chameleon
////
////  Created by Ian Keen on 13/06/2016.
////
////
//
////
//// Taken from Vapor: https://github.com/qutheory/vapor/blob/master/Sources/Vapor/Hash/Int%2BRandom.swift
////
//#if os(Linux)
//    @_exported import Glibc
//#else
//    @_exported import Darwin.C
//#endif
//
//public extension Int {
//    /**
//     Generates a random number between (and inclusive of)
//     the given minimum and maxiumum.
//     */
//    public static func random(min: Int, max: Int) -> Int {
//        let top = max - min + 1
//        #if os(Linux)
//            return Int(Glibc.random() % top) + min
//        #else
//            return Int(arc4random_uniform(UInt32(top))) + min
//        #endif
//    }
//}
