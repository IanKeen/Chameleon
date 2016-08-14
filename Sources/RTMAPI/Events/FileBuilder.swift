import Models

private enum FileEvent: String, RTMAPIEventBuilderEventType {
    case
    file_created, file_shared, file_unshared,
    file_public, file_private, file_change, file_deleted,
    file_comment_added, file_comment_edited, file_comment_deleted
    
    static var all: [FileEvent] {
        return [.file_created, .file_shared, .file_unshared,
                .file_public, .file_private, .file_change, .file_deleted,
                .file_comment_added, .file_comment_edited, .file_comment_deleted]
    }
}

/// Handler for the file events
struct FileBuilder: RTMAPIEventBuilder {
    static var eventTypes: [String] { return FileEvent.all.map({ $0.rawValue }) }
    
    static func make(withJson json: [String: Any], builderFactory: (json: [String: Any]) -> SlackModelBuilder) throws -> RTMAPIEvent {
        guard let event = FileEvent.eventType(fromJson: json)
            else { throw RTMAPIEventBuilderError.invalidBuilder(builder: self) }
        
        let builder = builderFactory(json: json)
        
        switch event {
        case .file_change:
            return .file_change(file: try builder.model("file"))
        case .file_created:
            return .file_created(file: try builder.model("file"))
        case .file_private:
            return .file_private(fileId: try builder.property("file"))
        case .file_public:
            return .file_public(file: try builder.model("file"))
        case .file_shared:
            return .file_shared(file: try builder.model("file"))
        case .file_unshared:
            return .file_unshared(file: try builder.model("file"))
        case .file_deleted:
            return .file_deleted(
                fileId: try builder.property("file_id"),
                timestamp: try builder.property("event_ts")
            )
        case .file_comment_added:
            return .file_comment_added(
                file: try builder.model("file"),
                comment: ""//try builder.property("event_ts")
            )
        case .file_comment_edited:
            return .file_comment_edited(
                file: try builder.model("file"),
                comment: ""//try builder.property("event_ts")
            )
        case .file_comment_deleted:
            return .file_comment_deleted(
                file: try builder.model("file"),
                commentId: try builder.property("comment")
            )
        }
    }
}
