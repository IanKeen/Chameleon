//
//  Shims.swift
//  Chameleon
//
//  Created by Ian Keen on 25/07/2016.
//
//

#if os(Linux)
public typealias TimeInterval = NSTimeInterval
typealias Date = NSDate
#endif
