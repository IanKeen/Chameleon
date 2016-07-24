//
//  Message+AttachmentFields.swift
//  Chameleon
//
//  Created by Ian Keen on 20/07/2016.
//
//

public protocol MessageAttachmentField: SlackModelType {
    var title: String { get }
    var value: String { get }
    
    func asField() -> Message.Attachment.Field?
    func asButton() -> Message.Attachment.Button?
}

extension MessageAttachmentField {
    public func asField() -> Message.Attachment.Field? { return nil }
    public func asButton() -> Message.Attachment.Button? { return nil }
}

//extension Message.Attachment.Field: MessageAttachmentField {
//    public func asField() -> Message.Attachment.Field? { return self }
//}
//extension Message.Attachment.Button: MessageAttachmentField {
//    public var title: String { return self.name }
//    public func asButton() -> Message.Attachment.Button? { return self }
//}
