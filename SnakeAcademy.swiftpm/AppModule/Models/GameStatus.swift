import Foundation

enum GameStatus: Equatable, Codable {
    case ready
    case running
    case paused
    case gameOver(reason: String)

    var isRunning: Bool {
        self == .running
    }

    var gameOverReason: String? {
        if case let .gameOver(reason) = self {
            return reason
        }
        return nil
    }
}
