//
//  Int+Extensions.swift
// Chameleon
//
//  Created by Ian Keen on 8/06/2016.
//
//

/// Represents how a number should be clamped
public enum Clamping {
    /// Min and Max should be included (i.e. >= and <=)
    case inclusive
    
    /// Min and Max should be excluded (i.e. > and <)
    case exclusive
    
    /// Provides the lower bound operator depending on the type of clamping
    private var minOperator: (Int, Int) -> Bool {
        switch self {
        case .inclusive: return (>=)
        case .exclusive: return (>)
        }
    }
    
    /// Provides the upper bound operator depending on the type of clamping
    private var maxOperator: (Int, Int) -> Bool {
        switch self {
        case .inclusive: return (<=)
        case .exclusive: return (<)
        }
    }
}

extension Int {
    /**
     Find out if `self` is between two other `Int`s
     Order does *not* matter
     
     - parameter first:    First number
     - parameter second:   Second number
     - parameter clamping: Clamping to apply
     
     - returns: `true` is `self` is between `first` and `second` otherwise `false`
     */
    public func between(_ first: Int, and second: Int, _ clamping: Clamping = .inclusive) -> Bool {
        return clamping.minOperator(self, Swift.min(first, second)) &&
            clamping.maxOperator(self, Swift.max(first, second))
    }
}
