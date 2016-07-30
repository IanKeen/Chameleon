//
//  RTMStart+Options.swift
//  Chameleon
//
//  Created by Ian Keen on 14/06/2016.
//
//

public extension RTMStart {
    /// Defines the options available when sending a message.
    public enum Option {
        /// Return timestamp only for latest message object of each channel (improves performance).
        case simpleLatest(Bool)
        
        /// Skip unread counts for each channel (improves performance).
        case noUnreads(Bool)
        
        /// Returns MPIMs to the client in the API response.
        case mpimAware(Bool)
    }
}

extension RTMStart.Option: OptionRepresentable {
    var key: String {
        switch self {
        case .simpleLatest: return "simple_latest"
        case .noUnreads: return "link_names"
        case .mpimAware: return "unfurl_links"
        }
    }
    var value: String {
        switch self {
        case .simpleLatest(let value): return try! String(value)
        case .noUnreads(let value): return try! String(value)
        case .mpimAware(let value): return try! String(value)
        }
    }
}
