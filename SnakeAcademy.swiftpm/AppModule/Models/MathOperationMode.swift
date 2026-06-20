import Foundation

enum MathOperationMode: String, CaseIterable, Identifiable, Codable {
    case addition
    case subtraction
    case multiplication
    case division
    case mixed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .addition:
            return "Addition Snake"
        case .subtraction:
            return "Subtraction Snake"
        case .multiplication:
            return "Multiplication Snake"
        case .division:
            return "Division Snake"
        case .mixed:
            return "Mixed Math Snake"
        }
    }

    var symbol: String {
        switch self {
        case .addition:
            return "+"
        case .subtraction:
            return "-"
        case .multiplication:
            return "x"
        case .division:
            return "/"
        case .mixed:
            return "?"
        }
    }
}
