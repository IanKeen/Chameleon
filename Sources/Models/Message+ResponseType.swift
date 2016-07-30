//
//  Message+ResponseType.swift
//  Chameleon
//
//  Created by Ian Keen on 22/07/2016.
//
//

public extension Message {
    public enum ResponseType: String, SlackModelValueType {
        case in_channel
        case ephemeral
    }
}
