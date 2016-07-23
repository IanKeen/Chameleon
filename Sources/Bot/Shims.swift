//
//  Shims.swift
//  Chameleon
//
//  Created by Ian Keen on 23/07/2016.
//
//

import Foundation

public typealias Date = NSDate
public typealias URL = NSURL

#if os(Linux)
    public typealias TimeInterval = NSTimeInterval
    public typealias ProcessInfo = NSProcessInfo
#endif
