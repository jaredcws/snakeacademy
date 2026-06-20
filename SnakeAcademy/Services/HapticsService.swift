#if canImport(UIKit)
import UIKit
#endif

final class HapticsService {
    static let shared = HapticsService()

    private init() {}

    func success() {
        #if canImport(UIKit)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }

    func warning() {
        #if canImport(UIKit)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        #endif
    }
}
