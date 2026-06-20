import Foundation

final class WordValidator {
    private let words: Set<String>

    init(words: Set<String> = WordValidator.defaultWords) {
        self.words = Set(words.map { $0.uppercased() })
    }

    func isValid(_ word: String) -> Bool {
        let normalized = word.uppercased()
        return normalized.count >= 3 && words.contains(normalized)
    }

    static let defaultWords: Set<String> = [
        "CAT", "DOG", "SUN", "MOON", "STAR", "FISH", "BIRD", "TREE", "BOOK", "GAME",
        "SNAKE", "APPLE", "HOUSE", "WATER", "LIGHT", "TRAIN", "PLANE", "SMILE",
        "HAPPY", "GREEN", "BLUE", "RED", "YELLOW", "ORANGE", "PURPLE", "MATH",
        "WORD", "LEARN", "SCHOOL", "CLASS", "TABLE", "CHAIR", "PHONE", "CLOUD",
        "RIVER", "OCEAN", "MUSIC", "PIZZA", "TIGER", "LION", "ZEBRA", "HORSE",
        "SHEEP", "BREAD", "WORLD", "SPACE", "EARTH", "BRAVE", "SMART", "QUICK"
    ]
}
