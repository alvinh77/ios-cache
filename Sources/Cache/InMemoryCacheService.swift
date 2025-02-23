import Foundation

public struct InMemoryCacheService: Sendable {
    private let getObeject: @Sendable (_ forKey: NSString) -> SendableObject?
    private let setObeject: @Sendable (_ object: SendableObject, _ forKey: NSString) -> Void
    private let removeObeject: @Sendable (_ forKey: NSString) -> Void
    private let removeAllObjects: @Sendable () -> Void

    init(
        getObeject: @escaping @Sendable (_ forKey: NSString) -> SendableObject?,
        setObeject: @escaping @Sendable (_ object: SendableObject?, _ forKey: NSString) -> Void,
        removeObeject: @escaping @Sendable (_ forKey: NSString) -> Void,
        removeAllObjects: @escaping @Sendable () -> Void
    ) {
        self.getObeject = getObeject
        self.setObeject = setObeject
        self.removeObeject = removeObeject
        self.removeAllObjects = removeAllObjects
    }

    public func getContent(forKey: String) -> Sendable? {
        getObeject(NSString(string: forKey))?.content
    }

    public func setContent(_ content: Sendable, forKey: String) {
        setObeject(.init(content: content), NSString(string: forKey))
    }

    public func removeContent(forKey: String) {
        removeObeject(NSString(string: forKey))
    }

    public func flush() {
        removeAllObjects()
    }
}

extension InMemoryCacheService {
    public init(cache: NSCache<NSString, SendableObject> = .init()) {
        self.getObeject = cache.object(forKey:)
        self.setObeject = cache.setObject(_:forKey:)
        self.removeObeject = cache.removeObject(forKey:)
        self.removeAllObjects = cache.removeAllObjects
    }
}

extension NSCache: @unchecked @retroactive Sendable {}
