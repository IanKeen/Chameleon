//
//  ConfigItems.swift
//  Chameleon
//
//  Created by Ian Keen on 4/08/2016.
//
//

struct StorageURL: ConfigItem {
    static var variableName: String { return "STORAGE_URL" }
    static var description: String {
        return "The value that will be sent to your `Storage` object if it requires one\n\n" +
            "For example, if you are using redis this might be:\n" +
            "redis://<user>:<pass>@redis.host.com:<port>"
    }
}
struct Token: ConfigItem {
    static var variableName: String { return "TOKEN" }
    static var description: String {
        return "The token the bot will use to authenticate if you are not using OAuth"
    }
}
struct ReconnectionAttempts: ConfigItem {
    static var variableName: String { return "RECONNECTION_ATTEMPTS" }
    static var description: String {
        return "The number of times the bot will attempt a reconnection after a failed" +
                "attempt or being disconnected"
    }
    static var `default`: String? { return "3" }
}
struct PingPongInterval: ConfigItem {
    static var variableName: String { return "PING_PONG_INTERVAL" }
    static var description: String {
        return "The number of seconds between each PING that is sent to the slack server.\n" +
                "This is required to keep the bots connection alive so it should be a fairly low number"
    }
    static var `default`: String? { return "5.0" }
}
struct OAuthClientID: ConfigItem {
    static var variableName: String { return "CLIENT_ID" }
    static var description: String {
        return "The client id the bot will use to authenticate if you are using OAuth"
    }
    static var itemSet: [ConfigItem.Type] { return [OAuthClientID.self, OAuthClientSecret.self] }
}
struct OAuthClientSecret: ConfigItem {
    static var variableName: String { return "CLIENT_SECRET" }
    static var description: String {
        return "The client secret the bot will use to authenticate if you are using OAuth"
    }
    static var itemSet: [ConfigItem.Type] { return [OAuthClientID.self, OAuthClientSecret.self] }
}
