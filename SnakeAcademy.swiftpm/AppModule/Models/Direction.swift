import Foundation

enum Direction: String, CaseIterable, Codable {
    case up
    case down
    case left
    case right

    var delta: (dx: Int, dy: Int) {
        switch self {
        case .up:
            return (0, 1)
        case .down:
            return (0, -1)
        case .left:
            return (-1, 0)
        case .right:
            return (1, 0)
        }
    }

    func isOpposite(to other: Direction) -> Bool {
        switch (self, other) {
        case (.up, .down), (.down, .up), (.left, .right), (.right, .left):
            return true
        default:
            return false
        }
    }
}
