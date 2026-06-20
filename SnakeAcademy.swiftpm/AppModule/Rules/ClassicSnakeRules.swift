import Foundation

final class ClassicSnakeRules: GameRules {
    let mode: GameMode = .classic

    func start(engine: SnakeGameEngine) {
        engine.spawnCollectible(kind: .food)
    }

    func handleCollectedTile(_ tile: Collectible, engine: SnakeGameEngine) {
        guard tile.kind == .food else {
            return
        }
        engine.addScore(1)
        engine.addGrowth(1)
        engine.spawnCollectible(kind: .food)
    }

    func makeHUDState(engine: SnakeGameEngine) -> HUDState {
        HUDState(
            mode: mode,
            score: engine.score,
            highScore: engine.persistence.highScore(for: mode),
            snakeLength: engine.snake.count,
            currentWord: "",
            lastCompletedWord: "",
            bestWord: engine.persistence.bestWord,
            mathProblemText: "",
            mathModeTitle: "",
            mathStreak: 0
        )
    }
}
