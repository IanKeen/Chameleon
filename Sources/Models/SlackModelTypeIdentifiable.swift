//
//  SlackModelTypeIdentifiable.swift
//  Slack
//
//  Created by Ian Keen on 20/05/2016.
//  Copyright © 2016 Mustard. All rights reserved.
//

public protocol SlackModelTypeIdentifiable {
    var id: String { get }
}

extension User: SlackModelTypeIdentifiable { }
extension Channel: SlackModelTypeIdentifiable { }
extension Group: SlackModelTypeIdentifiable { }
extension IM: SlackModelTypeIdentifiable { }
