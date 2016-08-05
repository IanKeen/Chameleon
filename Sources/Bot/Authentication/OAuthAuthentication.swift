//
//  OAuthAuthentication.swift
//  Chameleon
//
//  Created by Ian Keen on 1/08/2016.
//
//

import Foundation
import Services

/// Describes the range of possible errors that can occur when authenticating using OAuth
enum OAuthAuthenticationError: Error, CustomStringConvertible {
    /// A derived url was invalid
    case invalidURL
    
    /// A received response was invalid
    case invalidResponse(data: Any)
    
    /// A generic error (usually received from the server)
    case genericError(reason: String)
    
    var description: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse(let data): return "Invalid Response: \(data)"
        case .genericError(let reason): return "OAuth Failed: \(reason)"
        }
    }
}

/// Handles oauth authentication
final class OAuthAuthentication: SlackAuthenticator {
    //MARK: - Private
    private let http: HTTPService
    private let server: HTTPServer
    private let clientId: String
    private let clientSecret: String
    private var state = ""
    
    //MARK: - Lifecycle
    init(http: HTTPService, server: HTTPServer, clientId: String, clientSecret: String) {
        self.http = http
        self.server = server
        self.clientId = clientId
        self.clientSecret = clientSecret
        
        self.configureServer()
    }
    
    //MARK: - Authentication
    func authenticate(success: (token: String) -> Void, failure: (error: Error) -> Void) {
        do {
            let oAuthPath = try self.obtainOAuthPath()
            
            let oAuthURL = "http://slack.com/\(oAuthPath)"
            print(oAuthURL)
            // user goes to url, follows prompts, gets a code.. needs to feed back in here somehow
            
            //let token = try self.exchange(code: <#T##String#>)
            //success(token: token)
            
        } catch let error {
            failure(error: error)
        }
    }
    
    private func obtainOAuthPath() throws -> String {
        self.state = "\(Int.random(min: 1, max: 999999))"
        
        let components = NSURLComponents(string: "https://slack.com/oauth/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "scope", value: "bot"),
            URLQueryItem(name: "state", value: self.state),
        ]
        
        guard let url = components?.url else { throw OAuthAuthenticationError.invalidURL }
        
        let request = HTTPRequest(method: .get, url: url)
        let (headers, _) = try self.http.perform(with: request)
        
        guard let path = headers["Location"] else { throw OAuthAuthenticationError.invalidResponse(data: headers) }
        
        return path
    }
    private func exchange(code: String) throws -> String {
        let components = NSURLComponents(string: "https://slack.com/api/oauth.access")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "client_secret", value: self.clientSecret),
            URLQueryItem(name: "code", value: code),
        ]
        
        guard let url = components?.url else { throw OAuthAuthenticationError.invalidURL }
        
        let request = HTTPRequest(method: .get, url: url)
        let (_, json) = try self.http.perform(with: request)
        
        if json.keyPathExists("bot.bot_access_token") {
            return try json.keyPathValue("bot.bot_access_token")
        }
        
        let error: String = (try? json.keyPathValue("error")) ?? "Unknown Error"
        throw OAuthAuthenticationError.genericError(reason: error)
    }
}

//MARK: - Config
extension OAuthAuthentication {
    static func makeAuthenticator(parameters: (http: HTTPService, server: HTTPServer)) -> (Config) -> OAuthAuthentication? {
        return { config in
            guard
                let clientId: String = config.value(for: "CLIENT_ID"),
                let clientSecret: String = config.value(for: "CLIENT_SECRET")
                else { return nil }
            
            return OAuthAuthentication(
                http: parameters.http,
                server: parameters.server,
                clientId: clientId,
                clientSecret: clientSecret
            )
        }
    }
}

//MARK: - HTTPServer
extension OAuthAuthentication {
    private func configureServer() {
        self.server.respond(to: .get, at: ["/oauth"], with: self, OAuthAuthentication.serverOAuthRequest)
    }
    
    private func serverOAuthRequest(headers: [String: String], json: [String: Any]?) throws {
        print("HEADER: \(headers)")
        print("JSON: \(json)")
        print("")
    }
}
