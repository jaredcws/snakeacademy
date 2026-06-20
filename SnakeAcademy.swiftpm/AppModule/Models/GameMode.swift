import Foundation

enum GameMode: String, CaseIterable, Identifiable, Codable {
    case classic
    case word
    case math

    var id: String { rawValue }

    var title: String {
        switch self {
        case .classic:
            return "Classic Snake"
        case .word:
            return "Word Snake"
        case .math:
            return "Math Snake"
        }
    }
}
