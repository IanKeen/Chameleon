//
//  Sequence+Extensions.swift
// Chameleon
//
//  Created by Ian Keen on 10/06/2016.
//
//

import Foundation

public extension Collection {
    /**
     Provides a non-exceptional subscript for accessing an arrays elements
    
     - parameter safe: Index of the element
     
     - returns: The relevant element if the index is within the bounds of the array; otherwise nil
     */
    public subscript(safe safe: Index) -> Iterator.Element? {
        guard safe >= self.startIndex && safe <= self.endIndex else { return nil }
        return self[safe]
    }
}
