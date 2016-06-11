//
//  Sequence+Extensions.swift
//  Slack
//
//  Created by Ian Keen on 10/06/2016.
//
//

import Foundation

public extension Collection {
    public subscript(safe safe: Index) -> Iterator.Element? {
        guard safe >= self.startIndex && safe <= self.endIndex else { return nil }
        return self[safe]
    }
}
