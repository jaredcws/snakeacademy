import Foundation

final class MathSnakeRules: GameRules {
    let mode: GameMode = .math

    private let operationMode: MathOperationMode
    private let difficulty: Difficulty
    private let generator: MathProblemGenerator
    private(set) var currentProblem: MathProblem
    private(set) var streak = 0

    init(
        operationMode: MathOperationMode,
        difficulty: Difficulty,
        generator: MathProblemGenerator = MathProblemGenerator()
    ) {
        self.operationMode = operationMode
        self.difficulty = difficulty
        self.generator = generator
        self.currentProblem = generator.makeProblem(operationMode: operationMode, difficulty: difficulty)
    }

    func start(engine: SnakeGameEngine) {
        streak = 0
        currentProblem = generator.makeProblem(operationMode: operationMode, difficulty: difficulty)
        spawnNumberTiles(engine: engine)
    }

    func handleCollectedTile(_ tile: Collectible, engine: SnakeGameEngine) {
        guard case let .number(value, isCorrectAnswer) = tile.kind else {
            return
        }

        if isCorrectAnswer || value == currentProblem.answer {
            engine.addScore(10)
            engine.addGrowth(2)
            streak += 1
            engine.persistence.saveMathBestStreak(streak)
            engine.persistence.incrementMathProblemsSolved()
            currentProblem = generator.makeProblem(operationMode: operationMode, difficulty: difficulty)
            spawnNumberTiles(engine: engine)
        } else {
            engine.addScore(-5)
            streak = 0
            replaceWrongDistractor(engine: engine)
        }
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
            mathProblemText: currentProblem.prompt,
            mathModeTitle: operationMode.title,
            mathStreak: streak
        )
    }

    private func spawnNumberTiles(engine: SnakeGameEngine) {
        engine.collectibles.removeAll { collectible in
            if case .number = collectible.kind {
                return true
            }
            return false
        }

        var values = [currentProblem.answer]
        values.append(contentsOf: generator.makeDistractors(for: currentProblem, count: 9))

        for value in values.shuffled() {
            let isCorrect = value == currentProblem.answer
            guard engine.spawnCollectible(kind: .number(value, isCorrectAnswer: isCorrect)) != nil else {
                return
            }
        }
    }

    private func replaceWrongDistractor(engine: SnakeGameEngine) {
        let existingNumbers = Set(engine.collectibles.compactMap { collectible -> Int? in
            if case let .number(value, _) = collectible.kind {
                return value
            }
            return nil
        })

        let candidate = generator.makeDistractors(for: currentProblem, count: 12)
            .first { value in
                value != currentProblem.answer && !existingNumbers.contains(value)
            } ?? max(0, currentProblem.answer + 1)

        engine.spawnCollectible(kind: .number(candidate, isCorrectAnswer: false))
    }
}
