import XCTest
@testable import SnakeAcademy

@MainActor
final class SnakeAcademyTests: XCTestCase {
    private var persistence: PersistenceService!
    private var suiteName: String!

    override func setUp() {
        super.setUp()
        suiteName = "SnakeAcademyTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        persistence = PersistenceService(defaults: defaults)
    }

    override func tearDown() {
        if let suiteName {
            UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        }
        persistence = nil
        suiteName = nil
        super.tearDown()
    }

    func testInitialSnakeLengthIsFour() {
        let engine = makeEngine()
        engine.startNewGame(mode: .classic, difficulty: .easy)

        XCTAssertEqual(engine.snake.count, 4)
    }

    func testSnakeMovesOneCellPerStep() {
        let engine = makeEngine()
        engine.startNewGame(mode: .classic, difficulty: .easy)
        let firstHead = engine.snake[0]

        engine.step()

        XCTAssertEqual(engine.snake[0], firstHead.moved(.right))
    }

    func testSnakeCannotReverseDirectly() {
        let engine = makeEngine()
        engine.startNewGame(mode: .classic, difficulty: .easy)

        engine.updateDirection(.left)
        engine.step()

        XCTAssertEqual(engine.direction, .right)
    }

    func testWallCollisionEndsGame() {
        let engine = makeEngine()
        engine.startNewGame(mode: .classic, difficulty: .easy)
        engine.snake = [GridPoint(x: engine.configuration.columns - 1, y: 4)]
        engine.direction = .right
        engine.pendingDirection = .right

        engine.step()

        XCTAssertNotNil(engine.status.gameOverReason)
    }

    func testSelfCollisionEndsGame() {
        let engine = makeEngine()
        engine.startNewGame(mode: .classic, difficulty: .easy)
        engine.snake = [
            GridPoint(x: 4, y: 4),
            GridPoint(x: 4, y: 5),
            GridPoint(x: 3, y: 5),
            GridPoint(x: 3, y: 4),
            GridPoint(x: 3, y: 3)
        ]
        engine.direction = .up
        engine.pendingDirection = .up

        engine.step()

        XCTAssertNotNil(engine.status.gameOverReason)
    }

    func testEatingCollectibleGrowsSnake() {
        let engine = makeEngine()
        engine.startNewGame(mode: .classic, difficulty: .easy)
        let target = engine.snake[0].moved(.right)
        engine.collectibles = [Collectible(position: target, kind: .food)]
        let originalLength = engine.snake.count

        engine.step()

        XCTAssertEqual(engine.score, 1)
        XCTAssertEqual(engine.snake.count, originalLength + 1)
    }

    func testClassicFoodAddsScoreAndRespawns() {
        let engine = makeEngine()
        let rules = ClassicSnakeRules()
        engine.startNewGame(mode: .classic, difficulty: .easy)
        engine.collectibles = []

        rules.handleCollectedTile(Collectible(position: GridPoint(x: 0, y: 0), kind: .food), engine: engine)

        XCTAssertEqual(engine.score, 1)
        XCTAssertEqual(engine.growthPending, 1)
        XCTAssertEqual(engine.collectibles.count, 1)
    }

    func testWordValidatorAcceptsValidWords() {
        let validator = WordValidator(words: ["CAT"])

        XCTAssertTrue(validator.isValid("CAT"))
        XCTAssertFalse(validator.isValid("CA"))
        XCTAssertFalse(validator.isValid("CART"))
    }

    func testWordRulesCompleteAndClearWord() {
        let engine = makeEngine()
        let rules = WordSnakeRules(validator: WordValidator(words: ["CAT"]))
        engine.startNewGame(mode: .classic, difficulty: .easy)
        engine.collectibles = []

        rules.handleCollectedTile(Collectible(position: GridPoint(x: 0, y: 0), kind: .letter("C")), engine: engine)
        rules.handleCollectedTile(Collectible(position: GridPoint(x: 0, y: 0), kind: .letter("A")), engine: engine)
        XCTAssertEqual(rules.currentWord, "CA")

        rules.handleCollectedTile(Collectible(position: GridPoint(x: 0, y: 0), kind: .letter("T")), engine: engine)

        XCTAssertEqual(engine.score, 10)
        XCTAssertEqual(engine.growthPending, 3)
        XCTAssertEqual(rules.currentWord, "")
        XCTAssertEqual(rules.lastCompletedWord, "CAT")
    }

    func testWordScoreTable() {
        let rules = WordSnakeRules()

        XCTAssertEqual(rules.score(forWordLength: 3), 10)
        XCTAssertEqual(rules.score(forWordLength: 4), 20)
        XCTAssertEqual(rules.score(forWordLength: 5), 35)
        XCTAssertEqual(rules.score(forWordLength: 6), 50)
        XCTAssertEqual(rules.score(forWordLength: 7), 75)
        XCTAssertEqual(rules.score(forWordLength: 8), 100)
    }

    func testMathProblemGeneration() {
        let generator = MathProblemGenerator()

        for _ in 0..<50 {
            let subtraction = generator.makeProblem(operationMode: .subtraction, difficulty: .hard)
            XCTAssertGreaterThanOrEqual(subtraction.answer, 0)

            let division = generator.makeProblem(operationMode: .division, difficulty: .hard)
            XCTAssertNotEqual(division.right, 0)
            XCTAssertEqual(division.left % division.right, 0)
            XCTAssertEqual(division.left / division.right, division.answer)

            let addition = generator.makeProblem(operationMode: .addition, difficulty: .easy)
            XCTAssertEqual(addition.left + addition.right, addition.answer)
        }
    }

    func testMathCorrectAnswerScoresAndGrows() {
        let engine = makeEngine()
        let rules = MathSnakeRules(operationMode: .addition, difficulty: .easy)
        engine.startNewGame(mode: .classic, difficulty: .easy)

        rules.handleCollectedTile(
            Collectible(position: GridPoint(x: 0, y: 0), kind: .number(rules.currentProblem.answer, isCorrectAnswer: true)),
            engine: engine
        )

        XCTAssertEqual(engine.score, 10)
        XCTAssertEqual(engine.growthPending, 2)
        XCTAssertEqual(rules.streak, 1)
    }

    func testMathWrongAnswerSubtractsAndKeepsProblem() {
        let engine = makeEngine()
        let rules = MathSnakeRules(operationMode: .addition, difficulty: .easy)
        engine.startNewGame(mode: .classic, difficulty: .easy)
        let originalProblem = rules.currentProblem

        rules.handleCollectedTile(
            Collectible(position: GridPoint(x: 0, y: 0), kind: .number(originalProblem.answer + 99, isCorrectAnswer: false)),
            engine: engine
        )

        XCTAssertEqual(engine.score, -5)
        XCTAssertEqual(engine.growthPending, 0)
        XCTAssertEqual(rules.streak, 0)
        XCTAssertEqual(rules.currentProblem, originalProblem)
    }

    func testPersistenceHighScoreOnlyIncreases() {
        persistence.updateHighScore(20, for: .classic)
        persistence.updateHighScore(10, for: .classic)

        XCTAssertEqual(persistence.highScore(for: .classic), 20)
    }

    func testPersistenceSettingsSaveAndLoad() {
        persistence.selectedDifficulty = .hard
        persistence.musicEnabled = false
        persistence.soundEnabled = false

        XCTAssertEqual(persistence.selectedDifficulty, .hard)
        XCTAssertFalse(persistence.musicEnabled)
        XCTAssertFalse(persistence.soundEnabled)
    }

    private func makeEngine() -> SnakeGameEngine {
        SnakeGameEngine(persistence: persistence)
    }
}
