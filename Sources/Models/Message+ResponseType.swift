//
//  Message+ResponseType.swift
//  Chameleon
//
//  Created by Ian Keen on 22/07/2016.
//
//

public extension Message {
    public enum ResponseType: String, JSONRepresentable {
        case in_channel
        case ephemeral
    }
}
