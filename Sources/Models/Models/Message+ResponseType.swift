
/// Determines how a message is displayed in the channel
public enum MessageResponseType: String, SlackModelValueType {
    /// Message shows publicly in channel, visible to everyone
    case in_channel
    
    /// Message shows privately, only visible to the user that triggered the message
    case ephemeral
}
