import Foundation

struct GameConfiguration: Equatable {
    var difficulty: Difficulty

    var columns: Int {
        difficulty.gridSize
    }

    var rows: Int {
        difficulty.gridSize
    }

    var baseTickInterval: TimeInterval {
        difficulty.tickInterval
    }

    func contains(_ point: GridPoint) -> Bool {
        point.x >= 0 && point.y >= 0 && point.x < columns && point.y < rows
    }
}
