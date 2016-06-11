//
//  User+Extensions.swift
//  Slack
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

extension Sequence where Iterator.Element == User {
    public func botUsers() -> [User] {
        //Often the `id` used in things like `message.user.id` is the profile.bot_id
        //rather than the root `id` (because of course it is...)
        //so we add some duplicates using the `profile.bot_id` instead so we are covered
        //during lookups
        
        return self
            .filter { $0.bot_id != nil }
            .map { bot in
                var copy = bot
                copy.id = copy.bot_id!
                return copy
        }
    }
}