@testable import Cache
import Foundation
import Testing

struct InMemoryCacheServiceTests {
    @Test
    func getContent() async {
        await confirmation { gotObject in
            let service = InMemoryCacheService.mock(
                getObeject: { key in
                    gotObject()
                    #expect(key == "key")
                    return .init(content: "value")
                }
            )
            #expect(service.getContent(forKey: "key") as? String == "value")
        }
    }

    @Test
    func setContent() async {
        await confirmation { setObject in
            let service = InMemoryCacheService.mock(
                setObeject: { object, key in
                    #expect(object?.content as? String == "value")
                    #expect(key == "key")
                    setObject()
                }
            )
            service.setContent("value", forKey: "key")
        }
    }

    @Test
    func removeContent() async {
        await confirmation { removedObject in
            let service = InMemoryCacheService.mock(
                removeObeject: { key in
                    #expect(key == "key")
                    removedObject()
                }
            )
            service.removeContent(forKey: "key")
        }
    }

    @Test
    func flush() async {
        await confirmation { removedAllObjects in
            let service = InMemoryCacheService.mock(
                removeAllObjects: {
                    removedAllObjects()
                }
            )
            service.flush()
        }
    }

    @Test
    func concurrencySafe() async {
        let repeatTimes = 1_000
        let service = InMemoryCacheService()
        await withTaskGroup(of: Void.self) { taskGroup in
            (1...repeatTimes).forEach { index in
                taskGroup.addTask {
                    service.setContent(index, forKey: "\(index)")
                }
                taskGroup.addTask {
                    _ = service.getContent(forKey: "\(index)")
                }
                taskGroup.addTask {
                    service.removeContent(forKey: "\(index)")
                }
            }
            taskGroup.addTask {
                service.flush()
            }
        }
    }
}

extension InMemoryCacheService {
    static func mock(
        getObeject: @escaping @Sendable (_ forKey: NSString) -> SendableObject? = { _ in nil },
        setObeject: @escaping @Sendable (_ object: SendableObject?, _ forKey: NSString) -> Void = { _, _ in },
        removeObeject: @escaping @Sendable (_ forKey: NSString) -> Void = { _ in },
        removeAllObjects: @escaping @Sendable () -> Void = {}
    ) -> InMemoryCacheService {
        .init(
            getObeject: getObeject,
            setObeject: setObeject,
            removeObeject: removeObeject,
            removeAllObjects: removeAllObjects
        )
    }
}
