//
//  JSON+Subscript.swift
//  Chameleon
//
//  Created by Ian Keen on 13/06/2016.
//
//

import Vapor

//Original code from: https://github.com/Zewo/JSON/blob/master/Source/JSON.swift
//Modified to work with C7.JSON

extension JSON {
    public subscript(index: Int) -> JSON? {
        get {
            switch self {
            case .array(let array):
                return index < array.count ? array[index] : nil
            default: return nil
            }
        }
        
        set(json) {
            switch self {
            case .array(let array):
                var array = array
                if index < array.count {
                    if let json = json {
                        array[index] = json
                    } else {
                        array[index] = .null
                    }
                    self = .array(array)
                }
            default: break
            }
        }
    }
    
    public subscript(key: String) -> JSON? {
        get {
            switch self {
            case .object(let object):
                return object[key]
            default: return nil
            }
        }
        
        set(json) {
            switch self {
            case .object(let object):
                var object = object
                object[key] = json
                self = .object(object)
            default: break
            }
        }
    }
}
