import Foundation

@MainActor
protocol GameRules: AnyObject {
    var mode: GameMode { get }

    func start(engine: SnakeGameEngine)
    func handleCollectedTile(_ tile: Collectible, engine: SnakeGameEngine)
    func makeHUDState(engine: SnakeGameEngine) -> HUDState
}
