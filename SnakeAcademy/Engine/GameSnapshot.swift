import Foundation

struct GameSnapshot: Equatable {
    var mode: GameMode
    var difficulty: Difficulty
    var status: GameStatus
    var snake: [GridPoint]
    var direction: Direction
    var score: Int
    var growthPending: Int
    var collectibles: [Collectible]
    var configuration: GameConfiguration
    var hud: HUDState

    static let ready = GameSnapshot(
        mode: .classic,
        difficulty: .easy,
        status: .ready,
        snake: [],
        direction: .right,
        score: 0,
        growthPending: 0,
        collectibles: [],
        configuration: GameConfiguration(difficulty: .easy),
        hud: .empty
    )
}
