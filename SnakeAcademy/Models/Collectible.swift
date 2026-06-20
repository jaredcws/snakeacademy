import Foundation

enum CollectibleKind: Equatable {
    case food
    case letter(Character)
    case number(Int, isCorrectAnswer: Bool)
}

struct Collectible: Identifiable, Equatable {
    let id: UUID
    var position: GridPoint
    var kind: CollectibleKind

    init(id: UUID = UUID(), position: GridPoint, kind: CollectibleKind) {
        self.id = id
        self.position = position
        self.kind = kind
    }
}
