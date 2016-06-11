//
//  Target.swift
//  Slack
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public protocol Target {
    var id: String { get }
    var creator: User { get }
    var name: String { get }
    
    var channel: Channel? { get }
    var group: Group? { get }
    var instantMessage: IM? { get }
}
extension Target {
    public var channel: Channel? { return nil }
    public var group: Group? { return nil }
    public var instantMessage: IM? { return nil }
}

extension Channel: Target {
    public var channel: Channel? { return self }
}
extension Group: Target {
    public var group: Group? { return nil }
}
extension IM: Target {
    public var creator: User { return self.creator }
    public var name: String { return self.user.name }
    public var instantMessage: IM? { return self }
}
