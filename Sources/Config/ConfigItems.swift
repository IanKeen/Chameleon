public func AllConfigItems(including items: [ConfigItem.Type] = []) -> [ConfigItem.Type] {
    return [
        StorageURL.self,
        ReconnectionAttempts.self,
        PingPongInterval.self,
        RTMStartOptions.self,
        ] + items
}

public struct StorageURL: ConfigItem {
    public static var name: String { return "STORAGE_URL" }
    public static var description: String {
        return "The value that will be sent to your `Storage` object if it requires one\n\n" +
            "For example, if you are using redis this might be:\n" +
        "redis://<user>:<pass>@redis.host.com:<port>"
    }
}

public struct Token: ConfigItem {
    public static var name: String { return "TOKEN" }
    public static var description: String {
        return "The token the bot will use to authenticate if you are not using OAuth"
    }
}

public struct ReconnectionAttempts: ConfigItem {
    public static var name: String { return "RECONNECTION_ATTEMPTS" }
    public static var description: String {
        return "The number of times the bot will attempt a reconnection after a failed" +
        "attempt or being disconnected"
    }
    public static var `default`: String? { return "3" }
}

public struct PingPongInterval: ConfigItem {
    public static var name: String { return "PING_PONG_INTERVAL" }
    public static var description: String {
        return "The number of seconds between each PING that is sent to the slack server.\n" +
        "This is required to keep the bots connection alive so it should be a fairly low number"
    }
    public static var `default`: String? { return "5.0" }
}

public struct OAuthClientID: ConfigItem {
    public static var name: String { return "CLIENT_ID" }
    public static var description: String {
        return "The client id the bot will use to authenticate if you are using OAuth"
    }
    public static var itemSet: [ConfigItem.Type] { return [OAuthClientID.self, OAuthClientSecret.self] }
}

public struct OAuthClientSecret: ConfigItem {
    public static var name: String { return "CLIENT_SECRET" }
    public static var description: String {
        return "The client secret the bot will use to authenticate if you are using OAuth"
    }
    public static var itemSet: [ConfigItem.Type] { return [OAuthClientID.self, OAuthClientSecret.self] }
}

public struct RTMStartOptions: ConfigItem {
    public static var name: String { return "RTM_START_OPTIONS" }
    public static var description: String {
        return "The number of seconds between each PING that is sent to the slack server.\n" +
        "This is required to keep the bots connection alive so it should be a fairly low number"
    }
    public static var `default`: String? { return "" }
}
