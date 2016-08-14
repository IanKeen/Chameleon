import Models

/// Handler for the `group_rename` event
struct GroupRenameBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return ["group_rename"] }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard self.canMake(fromJson: json) else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        var group: Group = try builder.lookup("channel.id")
        let oldName = group.name
        
        let newName: String = try builder.property("channel.name")
        group = group.renamed(to: newName)
        
        return .group_rename(group: group, oldName: oldName)
    }
}
