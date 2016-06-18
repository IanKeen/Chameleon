//
//  KarmaBot.swift
//  Chameleon
//
//  Created by Ian Keen on 21/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

import Foundation
import Models
import Bot
import WebAPI
import RTMAPI

enum KarmaAction {
    case Add
    case Remove
    
    var operation: (Int, Int) -> Int {
        switch self {
        case .Add: return (+)
        case .Remove: return (-)
        }
    }
    
    func randomMessage(user: User, storage: Storage) -> String {
        let count: Int = storage.get(.In("Karma"), key: user.id, or: 0)
        let total = "Total: \(count)"
        
        switch self {
        case .Add: return "\(user.name) you rock! - \(total)"
        case .Remove: return "Boooo \(user.name)! - \(total)"
        }
    }
}

extension KarmaBot {
    struct Options {
        let targets: [String]?
        
        let addText: String?
        let addReaction: String?
        let removeText: String?
        let removeReaction: String?
        
        let textDistanceThreshold: Int
    }
}

final class KarmaBot: SlackRTMEventService, SlackMessageService {
    private let options: Options
    
    init(options: Options) {
        self.options = options
    }
    
    func event(slackBot: SlackBot, event: RTMAPIEvent, webApi: WebAPI) {
        switch event {
        case .reaction_added(let reaction, let user, let itemCreator, let target):
            guard
                let target = target,
                let itemCreator = itemCreator,
                let karma = self.karma(for: itemCreator, fromReaction: reaction)
                where user != itemCreator && self.isKarmaChannel(target)
                else { return }
            
            self.adjustKarma(of: itemCreator, action: karma, storage: slackBot.storage)
            
            slackBot.chat(
                with: target,
                text: karma.randomMessage(user: itemCreator, storage: slackBot.storage)
            )
            
        //case .reaction_removed: //TODO
            
        default: break
        }
    }
    
    func message(slackBot: SlackBot, message: MessageAdaptor, previous: MessageAdaptor?) {
        guard let target = message.target where self.isKarmaChannel(target) else { return }
        
        let response = message
            .mentioned_users
            .flatMap { (user: User) -> (User, KarmaAction)? in
                guard let karma = self.karma(for: user, from: message) else { return nil }
                return (user, karma)
            }
            .map { user, karma in
                self.adjustKarma(of: user, action: karma, storage: slackBot.storage)
                return karma.randomMessage(user: user, storage: slackBot.storage)
            }
            .joined(separator: "\n")
        
        guard !response.isEmpty else { return }
        
        slackBot.chat(with: target, text: response)
    }
    
    private func karma(for user: User, from message: MessageAdaptor) -> KarmaAction? {
        let userLink = "<@\(user.id)>"
        
        guard
            message.sender != user,
            let userIndex = message.text.range(of: userLink)?.upperBound
            else { return nil }
        
        if
            let add = self.options.addText,
            let possibleAdd = message.text.range(of: add)?.lowerBound
            where message.text.distance(from: userIndex, to: possibleAdd) <= self.options.textDistanceThreshold { return .Add }
        
        else if
            let remove = self.options.removeText,
            let possibleRemove = message.text.range(of: remove)?.lowerBound
            where message.text.distance(from: userIndex, to: possibleRemove) <= self.options.textDistanceThreshold { return .Remove }
        
        return nil
    }
    private func karma(for user: User, fromReaction reaction: String) -> KarmaAction? {
        if let add = self.options.addReaction where reaction.hasPrefix(add) { return .Add }
        else if let remove = self.options.removeReaction where reaction.hasPrefix(remove) { return .Remove }
        return nil
    }
    private func adjustKarma(of user: User, action: KarmaAction, storage: Storage) {
        do {
            let count: Int = storage.get(.In("Karma"), key: user.id, or: 0)
            try storage.set(.In("Karma"), key: user.id, value: action.operation(count, 1))
            
        } catch let error {
            print("Unable to update Karma: \(error)")
        }
    }
    
    private func isKarmaChannel(_ target: Target) -> Bool {
        guard let targets = self.options.targets else { return true }
        return targets.contains { $0 == target.name || $0 == "*" }
    }
}
