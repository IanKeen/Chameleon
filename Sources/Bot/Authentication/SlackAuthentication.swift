//
//  SlackAuthentication.swift
//  Chameleon
//
//  Created by Ian Keen on 1/08/2016.
//
//

/// Abstraction representing a means for the `SlackBot` to authenticate.
protocol SlackAuthenticator {
    associatedtype FactoryParameters
    
    /**
     Authenticate the `SlackBot`
     
     - parameter success:   This closure fires with the token needed for the `SlackBot` to authenticate
     - parameter failure:   This closure fires with the reason the authentication attempt failed
     */
    func authenticate(success: (token: String) -> Void, failure: (error: Error) -> Void)
    
    static func makeAuthenticator(parameters: FactoryParameters) -> (Config) -> Self?
}
