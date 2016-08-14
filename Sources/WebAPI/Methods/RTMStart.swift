import Models
import Services
import Common

/// Handler for the `rtm.start` endpoint
public struct RTMStart: WebAPIMethod {
    public typealias RTMStartData = (botUser: BotUser, team: Team, users: [User], channels: [Channel], groups: [Group], ims: [IM])
    public typealias SuccessParameters = (String)
    
    //MARK: - Private Properties
    private let options: [RTMStartOption]
    private let dataReady: (serializedData: () throws -> RTMStartData) -> Void
    
    //MARK: - Lifecycle
    /**
     Create a new `RTMStart` instance
     
     NOTE: The `RTMStart` method is performed on another thread.
     
     When signing in all the data for users, channels, groups and IMs needs to be parsed to achieve a typed experience.
     On larger teams this could cause the websocket link to timeout before this processing is done.
     By moving this work to another thread we can continue connecting and then complete the start up once the work here is done.
     
     - parameter options:   `RTMStartOption`s to use
     - parameter dataReady: The closure to call upon success; throws on failure
     
     - returns: A new instance
     */
    public init(options: [RTMStartOption] = [], dataReady: (serializedData: () throws -> RTMStartData) -> Void) {
        self.options = options
        self.dataReady = dataReady
    }
    
    //MARK: - Public
    public var networkRequest: HTTPRequest {
        let params = self.options.makeParameters()
        
        return HTTPRequest(
            method: .get,
            url: WebAPIURL("rtm.start"),
            parameters: params
        )
    }
    public func handle(headers: [String: String], json: [String: Any], slackModels: SlackModels) throws -> SuccessParameters {
        guard let socketUrl = json["url"] as? String else { throw WebAPIError.invalidResponse(json: json) }
        
        _ = inBackground {
            guard
                let selfJson = json["self"] as? [String: Any],
                let teamJson = json["team"] as? [String: Any],
                let userJson = json["users"] as? [[String: Any]],
                let channelJson = json["channels"] as? [[String: Any]],
                let groupJson = json["groups"] as? [[String: Any]],
                let imJson = json["ims"] as? [[String: Any]]
                else { return self.dataReady(serializedData: { throw WebAPIError.invalidResponse(json: json) }) }
            
            do {
                print("Deserializing Team")
                let team = try Team.makeModel(with: SlackModelBuilder.make(json: teamJson))
                
                print("Deserializing \(userJson.count) Users")
                let users = try userJson.map { try User.makeModel(with: SlackModelBuilder.make(json: $0)) }
                
                print("Deserializing \(channelJson.count) Channels")
                let channels = try channelJson.map { try Channel.makeModel(with: SlackModelBuilder.make(json: $0, users: users)) }
                
                print("Deserializing \(groupJson.count) Groups")
                let groups = try groupJson.map { try Group.makeModel(with: SlackModelBuilder.make(json: $0, users: users)) }
                
                print("Deserializing \(imJson.count) IMs")
                let ims = try imJson.map { try IM.makeModel(with: SlackModelBuilder.make(json: $0, users: users)) }
                
                print("Deserializing Bot User")
                let botUser = try BotUser.makeModel(with: SlackModelBuilder.make(json: selfJson))
                
                self.dataReady(serializedData: { return
                    (botUser: botUser,
                     team: team,
                     users: users,
                     channels: channels,
                     groups: groups,
                     ims: ims)
                })
                
            } catch let error {
                self.dataReady(serializedData: { throw error })
            }
        }
        return socketUrl
    }
}
