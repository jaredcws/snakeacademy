import Foundation

struct GridPoint: Hashable, Codable {
    var x: Int
    var y: Int

    func moved(_ direction: Direction) -> GridPoint {
        let delta = direction.delta
        return GridPoint(x: x + delta.dx, y: y + delta.dy)
    }
}
