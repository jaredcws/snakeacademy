import Foundation

@MainActor
final class SnakeSceneCoordinator {
    private let engine: SnakeGameEngine

    init(engine: SnakeGameEngine) {
        self.engine = engine
    }

    func move(_ direction: Direction) {
        engine.updateDirection(direction)
    }
}
