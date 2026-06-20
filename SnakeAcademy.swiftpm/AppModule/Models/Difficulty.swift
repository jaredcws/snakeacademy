import Foundation

enum Difficulty: String, CaseIterable, Identifiable, Codable {
    case easy
    case medium
    case hard

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var gridSize: Int {
        switch self {
        case .easy:
            return 20
        case .medium:
            return 25
        case .hard:
            return 30
        }
    }

    var tickInterval: TimeInterval {
        switch self {
        case .easy:
            return 0.18
        case .medium:
            return 0.14
        case .hard:
            return 0.10
        }
    }
}
