//
//  Message+ItemType.swift
//  Slack
//
//  Created by Ian Keen on 23/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public extension Message {
    public enum ItemType: String {
        case Channel = "C"
        case Group = "G"
        case File = "F"
        case FileComments = "Fc"
    }
}
