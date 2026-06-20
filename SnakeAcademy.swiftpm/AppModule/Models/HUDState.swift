import Foundation

struct HUDState: Equatable {
    var mode: GameMode
    var score: Int
    var highScore: Int
    var snakeLength: Int
    var currentWord: String
    var lastCompletedWord: String
    var bestWord: String
    var mathProblemText: String
    var mathModeTitle: String
    var mathStreak: Int

    static let empty = HUDState(
        mode: .classic,
        score: 0,
        highScore: 0,
        snakeLength: 0,
        currentWord: "",
        lastCompletedWord: "",
        bestWord: "",
        mathProblemText: "",
        mathModeTitle: "",
        mathStreak: 0
    )
}
