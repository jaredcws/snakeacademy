import Foundation

final class PersistenceService {
    static let shared = PersistenceService()

    enum Key {
        static let classicHighScore = "classicHighScore"
        static let wordHighScore = "wordHighScore"
        static let mathHighScore = "mathHighScore"
        static let bestWord = "bestWord"
        static let longestSnake = "longestSnake"
        static let mathBestStreak = "mathBestStreak"
        static let gamesPlayed = "gamesPlayed"
        static let totalScore = "totalScore"
        static let wordsCompleted = "wordsCompleted"
        static let mathProblemsSolved = "mathProblemsSolved"
        static let selectedDifficulty = "selectedDifficulty"
        static let musicEnabled = "musicEnabled"
        static let soundEnabled = "soundEnabled"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        registerDefaults()
    }

    var bestWord: String {
        defaults.string(forKey: Key.bestWord) ?? ""
    }

    var selectedDifficulty: Difficulty {
        get {
            guard let rawValue = defaults.string(forKey: Key.selectedDifficulty),
                  let difficulty = Difficulty(rawValue: rawValue) else {
                return .easy
            }
            return difficulty
        }
        set {
            defaults.set(newValue.rawValue, forKey: Key.selectedDifficulty)
        }
    }

    var musicEnabled: Bool {
        get { defaults.bool(forKey: Key.musicEnabled) }
        set { defaults.set(newValue, forKey: Key.musicEnabled) }
    }

    var soundEnabled: Bool {
        get { defaults.bool(forKey: Key.soundEnabled) }
        set { defaults.set(newValue, forKey: Key.soundEnabled) }
    }

    var longestSnake: Int {
        defaults.integer(forKey: Key.longestSnake)
    }

    var gamesPlayed: Int {
        defaults.integer(forKey: Key.gamesPlayed)
    }

    var totalScore: Int {
        defaults.integer(forKey: Key.totalScore)
    }

    var wordsCompleted: Int {
        defaults.integer(forKey: Key.wordsCompleted)
    }

    var mathProblemsSolved: Int {
        defaults.integer(forKey: Key.mathProblemsSolved)
    }

    func highScore(for mode: GameMode) -> Int {
        defaults.integer(forKey: highScoreKey(for: mode))
    }

    func updateHighScore(_ score: Int, for mode: GameMode) {
        guard score > highScore(for: mode) else {
            return
        }
        defaults.set(score, forKey: highScoreKey(for: mode))
    }

    func recordGame(mode: GameMode, score: Int, snakeLength: Int) {
        defaults.set(gamesPlayed + 1, forKey: Key.gamesPlayed)
        defaults.set(totalScore + score, forKey: Key.totalScore)

        if snakeLength > longestSnake {
            defaults.set(snakeLength, forKey: Key.longestSnake)
        }

        if score >= 0 || mode != .math {
            updateHighScore(score, for: mode)
        }
    }

    func saveBestWord(_ word: String) {
        guard word.count > bestWord.count else {
            return
        }
        defaults.set(word.uppercased(), forKey: Key.bestWord)
    }

    func saveMathBestStreak(_ streak: Int) {
        let current = defaults.integer(forKey: Key.mathBestStreak)
        if streak > current {
            defaults.set(streak, forKey: Key.mathBestStreak)
        }
    }

    func mathBestStreak() -> Int {
        defaults.integer(forKey: Key.mathBestStreak)
    }

    func incrementWordsCompleted() {
        defaults.set(wordsCompleted + 1, forKey: Key.wordsCompleted)
    }

    func incrementMathProblemsSolved() {
        defaults.set(mathProblemsSolved + 1, forKey: Key.mathProblemsSolved)
    }

    private func highScoreKey(for mode: GameMode) -> String {
        switch mode {
        case .classic:
            return Key.classicHighScore
        case .word:
            return Key.wordHighScore
        case .math:
            return Key.mathHighScore
        }
    }

    private func registerDefaults() {
        defaults.register(defaults: [
            Key.selectedDifficulty: Difficulty.easy.rawValue,
            Key.musicEnabled: true,
            Key.soundEnabled: true
        ])
    }
}
