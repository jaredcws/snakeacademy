import Foundation

struct SnakeSegment: Identifiable, Equatable {
    let id = UUID()
    var position: GridPoint
    var isHead: Bool
}
