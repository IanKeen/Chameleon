//
//  TokenAuthentication.swift
//  Chameleon
//
//  Created by Ian Keen on 1/08/2016.
//
//

/// Handles direct token authentication
struct TokenAuthentication: SlackAuthenticator {
    //MARK: - Private
    private let token: String
    
    //MARK: - Lifecycle
    init(token: String) {
        self.token = token
    }
    
    //MARK: - Authentication
    func authenticate(success: (token: String) -> Void, failure: (error: Error) -> Void) {
        success(token: self.token)
    }
}

extension TokenAuthentication {
    static func makeAuthenticator(parameters: Void) -> (Config) -> TokenAuthentication? {
        return { config in
            guard let token: String = config.value(for: "TOKEN") else { return nil }
            return TokenAuthentication(token: token)
        }
    }
}
