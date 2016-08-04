//
//  TokenAuthentication.swift
//  Chameleon
//
//  Created by Ian Keen on 1/08/2016.
//
//

/// Handles direct token authentication
public struct TokenAuthentication: SlackAuthenticator {
    //MARK: - Private
    private let token: String
    
    //MARK: - Lifecycle
    public init(token: String) {
        self.token = token
    }
    
    //MARK: - Authentication
    public func authenticate(success: (token: String) -> Void, failure: (error: Error) -> Void) {
        success(token: self.token)
    }
}
