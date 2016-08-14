
/// Represents the core slack types
public typealias SlackModels = (
    users: [User],
    channels: [Channel],
    groups: [Group],
    ims: [IM],
    team: Team?
)

public extension SlackModelBuilder {
    /**
     Creates a new `SlackModelBuilder` instance using the provided `[String: Any]`
     and, optionally, existing models
     
     - parameter json:     `[String: Any]` data to use when building models
     - parameter users:    optional: A `User` array
     - parameter channels: optional: A `Channel` array
     - parameter groups:   optional: A `Group` array
     - parameter ims:      optional: An `IM` array
     - parameter team:     optional: The `Team`
     
     - returns: A new `SlackModelBuilder` instance
     */
    public static func make(
        json: [String: Any],
        users: [User] = [],
        channels: [Channel] = [],
        groups: [Group] = [],
        ims: [IM] = [],
        team: Team? = nil) -> SlackModelBuilder {
        return SlackModelBuilder(
            json: json,
            users: users,
            channels: channels,
            groups: groups,
            ims: ims,
            team: team
        )
    }
    
    /**
     Creates a new `SlackModelBuilder` instance using the provided `[String: Any]`
     and existing models.
     
     NOTE: This is essentially a convenience builder for the Service layer
            The generally use a closure to grab the latest set of data on the fly
            and having this here cleans up each object as well as having a single 
            point of failure
     
     - parameter models:   A tuple containing all the currently obtained models (will crash if nil)
     - parameter json:     `[String: Any]` data to use when building models
     
     - returns: A new `SlackModelBuilder` instance
     */
    public static func make(models: SlackModels?) -> ([String: Any]) -> SlackModelBuilder {
        return { json in
            guard let models = models else { fatalError("No Slack models were provided") }
            
            return SlackModelBuilder(
                json: json,
                users: models.users,
                channels: models.channels,
                groups: models.groups,
                ims: models.ims,
                team: models.team
            )
        }
    }
}
