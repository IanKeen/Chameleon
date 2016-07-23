//
//  Shims.swift
//  Chameleon
//
//  Created by Ian Keen on 22/07/2016.
//
//

import Vapor

public typealias JSONRepresentable = Vapor.JSONRepresentable
public typealias JSON = Vapor.JSON
public typealias Bytes = Vapor.Bytes

import Foundation
public typealias Date = NSDate
public typealias URL = NSURL

#if os(Linux)
    public typealias TimeInterval = NSTimeInterval
    public typealias ProcessInfo = NSProcessInfo
#endif
