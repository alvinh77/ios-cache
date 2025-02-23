public final class SendableObject: Sendable {
    public let content: Sendable

    public init(content: Sendable) {
        self.content = content
    }
}
