//
//  User+Extensions.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public extension Sequence where Iterator.Element == User {
    /**
     Returns a sequence of `User` models that represent the bot users.
     
     Creating these 'mocks' allows smoother interactions with all users _including_ other bots.
     
     - returns: A list of bot users _lifted_ into `User` models
     */
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
