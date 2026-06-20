import Combine
import Foundation

@MainActor
final class SnakeGameEngine: ObservableObject {
    @Published private(set) var snapshot: GameSnapshot = .ready

    var snake: [GridPoint] = []
    var direction: Direction = .right
    var pendingDirection: Direction = .right
    var score: Int = 0
    var growthPending: Int = 0
    var status: GameStatus = .ready
    var collectibles: [Collectible] = []
    var configuration = GameConfiguration(difficulty: .easy)

    private(set) var currentMode: GameMode = .classic
    private(set) var currentMathMode: MathOperationMode?
    private var rules: GameRules?
    let persistence: PersistenceService

    init(persistence: PersistenceService = .shared) {
        self.persistence = persistence
        publishSnapshot()
    }

    var effectiveTickInterval: TimeInterval {
        guard currentMode == .classic else {
            return configuration.baseTickInterval
        }
        let speedSteps = min(score / 10, 6)
        return max(configuration.baseTickInterval - (Double(speedSteps) * 0.012), 0.075)
    }

    func startNewGame(mode: GameMode, difficulty: Difficulty, mathMode: MathOperationMode? = nil) {
        currentMode = mode
        currentMathMode = mathMode
        configuration = GameConfiguration(difficulty: difficulty)
        direction = .right
        pendingDirection = .right
        score = 0
        growthPending = 0
        status = .running
        collectibles = []

        let centerX = configuration.columns / 2
        let centerY = configuration.rows / 2
        snake = [
            GridPoint(x: centerX, y: centerY),
            GridPoint(x: centerX - 1, y: centerY),
            GridPoint(x: centerX - 2, y: centerY),
            GridPoint(x: centerX - 3, y: centerY)
        ]

        rules = makeRules(mode: mode, difficulty: difficulty, mathMode: mathMode)
        rules?.start(engine: self)
        publishSnapshot()
    }

    func updateDirection(_ newDirection: Direction) {
        guard !newDirection.isOpposite(to: direction) else {
            return
        }
        pendingDirection = newDirection
    }

    func step() {
        guard status == .running, let head = snake.first else {
            return
        }

        if !pendingDirection.isOpposite(to: direction) {
            direction = pendingDirection
        }

        let nextHead = head.moved(direction)
        guard configuration.contains(nextHead) else {
            finishGame(reason: "Hit the wall")
            return
        }

        var collisionBody = snake
        if growthPending == 0 {
            _ = collisionBody.popLast()
        }

        guard !collisionBody.contains(nextHead) else {
            finishGame(reason: "Hit yourself")
            return
        }

        snake.insert(nextHead, at: 0)

        if let index = collectibles.firstIndex(where: { $0.position == nextHead }) {
            let tile = collectibles.remove(at: index)
            rules?.handleCollectedTile(tile, engine: self)
        }

        if growthPending > 0 {
            growthPending -= 1
        } else if !snake.isEmpty {
            snake.removeLast()
        }

        publishSnapshot()
    }

    func pause() {
        guard status == .running else {
            return
        }
        status = .paused
        publishSnapshot()
    }

    func resume() {
        guard status == .paused else {
            return
        }
        status = .running
        publishSnapshot()
    }

    func restart() {
        startNewGame(mode: currentMode, difficulty: configuration.difficulty, mathMode: currentMathMode)
    }

    func clearWordTray() {
        guard let wordRules = rules as? WordSnakeRules else {
            return
        }
        wordRules.clearWord()
        publishSnapshot()
    }

    func addScore(_ amount: Int) {
        score += amount
    }

    func addGrowth(_ amount: Int) {
        growthPending += max(0, amount)
    }

    @discardableResult
    func spawnCollectible(kind: CollectibleKind) -> Collectible? {
        guard let point = randomEmptyPoint() else {
            finishGame(reason: "Board full")
            return nil
        }
        let collectible = Collectible(position: point, kind: kind)
        collectibles.append(collectible)
        return collectible
    }

    func randomEmptyPoint(excluding extraOccupied: Set<GridPoint> = []) -> GridPoint? {
        var occupied = Set(snake)
        occupied.formUnion(collectibles.map(\.position))
        occupied.formUnion(extraOccupied)

        var empty: [GridPoint] = []
        empty.reserveCapacity(configuration.columns * configuration.rows)

        for y in 0..<configuration.rows {
            for x in 0..<configuration.columns {
                let point = GridPoint(x: x, y: y)
                if !occupied.contains(point) {
                    empty.append(point)
                }
            }
        }

        return empty.randomElement()
    }

    func finishGame(reason: String) {
        status = .gameOver(reason: reason)
        persistence.recordGame(mode: currentMode, score: score, snakeLength: snake.count)
        publishSnapshot()
    }

    func publishSnapshot() {
        let hud = rules?.makeHUDState(engine: self) ?? HUDState(
            mode: currentMode,
            score: score,
            highScore: persistence.highScore(for: currentMode),
            snakeLength: snake.count,
            currentWord: "",
            lastCompletedWord: "",
            bestWord: persistence.bestWord,
            mathProblemText: "",
            mathModeTitle: "",
            mathStreak: 0
        )

        snapshot = GameSnapshot(
            mode: currentMode,
            difficulty: configuration.difficulty,
            status: status,
            snake: snake,
            direction: direction,
            score: score,
            growthPending: growthPending,
            collectibles: collectibles,
            configuration: configuration,
            hud: hud
        )
    }

    private func makeRules(mode: GameMode, difficulty: Difficulty, mathMode: MathOperationMode?) -> GameRules {
        switch mode {
        case .classic:
            return ClassicSnakeRules()
        case .word:
            return WordSnakeRules()
        case .math:
            return MathSnakeRules(operationMode: mathMode ?? .addition, difficulty: difficulty)
        }
    }
}
