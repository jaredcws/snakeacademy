import Foundation

struct MathProblem: Equatable {
    var left: Int
    var right: Int
    var operation: MathOperationMode
    var answer: Int

    var prompt: String {
        "\(left) \(operation.symbol) \(right) = ?"
    }
}
