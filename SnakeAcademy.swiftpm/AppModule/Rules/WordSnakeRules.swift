import Foundation

final class WordSnakeRules: GameRules {
    let mode: GameMode = .word

    private let validator: WordValidator
    private(set) var currentWord = ""
    private(set) var lastCompletedWord = ""
    private(set) var bestWord = ""

    init(validator: WordValidator = WordValidator()) {
        self.validator = validator
        self.bestWord = PersistenceService.shared.bestWord
    }

    func start(engine: SnakeGameEngine) {
        currentWord = ""
        lastCompletedWord = ""
        bestWord = engine.persistence.bestWord
        refillLetters(engine: engine)
    }

    func handleCollectedTile(_ tile: Collectible, engine: SnakeGameEngine) {
        guard case let .letter(letter) = tile.kind else {
            return
        }

        currentWord.append(String(letter).uppercased())

        if validator.isValid(currentWord) {
            let completedWord = currentWord.uppercased()
            engine.addScore(score(forWordLength: completedWord.count))
            engine.addGrowth(completedWord.count)
            lastCompletedWord = completedWord

            if completedWord.count > bestWord.count {
                bestWord = completedWord
                engine.persistence.saveBestWord(completedWord)
            }

            engine.persistence.incrementWordsCompleted()
            currentWord = ""
        }

        refillLetters(engine: engine)
    }

    func clearWord() {
        currentWord = ""
    }

    func score(forWordLength length: Int) -> Int {
        switch length {
        case 3:
            return 10
        case 4:
            return 20
        case 5:
            return 35
        case 6:
            return 50
        case 7:
            return 75
        default:
            return length >= 8 ? 100 : 0
        }
    }

    func makeHUDState(engine: SnakeGameEngine) -> HUDState {
        HUDState(
            mode: mode,
            score: engine.score,
            highScore: engine.persistence.highScore(for: mode),
            snakeLength: engine.snake.count,
            currentWord: currentWord,
            lastCompletedWord: lastCompletedWord,
            bestWord: bestWord,
            mathProblemText: "",
            mathModeTitle: "",
            mathStreak: 0
        )
    }

    private func refillLetters(engine: SnakeGameEngine) {
        while engine.collectibles.filter({ collectible in
            if case .letter = collectible.kind {
                return true
            }
            return false
        }).count < 12 {
            guard engine.spawnCollectible(kind: .letter(Self.randomLetter())) != nil else {
                return
            }
        }
    }

    private static func randomLetter() -> Character {
        let common = Array("AEIOURSTNLCDMP")
        let rare = Array("QXZJKVWY")
        let bag = common + common + common + rare
        return bag.randomElement() ?? "A"
    }
}
