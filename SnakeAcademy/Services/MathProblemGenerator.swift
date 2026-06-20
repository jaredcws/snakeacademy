import Foundation

struct MathProblemGenerator {
    func makeProblem(operationMode: MathOperationMode, difficulty: Difficulty) -> MathProblem {
        let operation = resolvedOperation(from: operationMode)

        switch operation {
        case .addition:
            let range = additiveRange(for: difficulty)
            let left = Int.random(in: range)
            let right = Int.random(in: range)
            return MathProblem(left: left, right: right, operation: .addition, answer: left + right)
        case .subtraction:
            let range = additiveRange(for: difficulty)
            let first = Int.random(in: range)
            let second = Int.random(in: range)
            let left = max(first, second)
            let right = min(first, second)
            return MathProblem(left: left, right: right, operation: .subtraction, answer: left - right)
        case .multiplication:
            let range = multiplicationRange(for: difficulty)
            let left = Int.random(in: range)
            let right = Int.random(in: range)
            return MathProblem(left: left, right: right, operation: .multiplication, answer: left * right)
        case .division:
            let answerRange = divisionAnswerRange(for: difficulty)
            let divisorRange = divisionDivisorRange(for: difficulty)
            let answer = Int.random(in: answerRange)
            let divisor = Int.random(in: divisorRange)
            return MathProblem(left: answer * divisor, right: divisor, operation: .division, answer: answer)
        case .mixed:
            return makeProblem(operationMode: resolvedOperation(from: .mixed), difficulty: difficulty)
        }
    }

    func makeDistractors(for problem: MathProblem, count: Int) -> [Int] {
        var values = Set<Int>()
        let answer = problem.answer
        let spread = max(8, abs(answer / 2) + 6)

        while values.count < count {
            let candidate = answer + Int.random(in: -spread...spread)
            if candidate != answer && candidate >= 0 {
                values.insert(candidate)
            }
        }

        return Array(values)
    }

    private func resolvedOperation(from operationMode: MathOperationMode) -> MathOperationMode {
        if operationMode == .mixed {
            return [.addition, .subtraction, .multiplication, .division].randomElement() ?? .addition
        }
        return operationMode
    }

    private func additiveRange(for difficulty: Difficulty) -> ClosedRange<Int> {
        switch difficulty {
        case .easy:
            return 0...20
        case .medium:
            return 0...50
        case .hard:
            return 0...100
        }
    }

    private func multiplicationRange(for difficulty: Difficulty) -> ClosedRange<Int> {
        switch difficulty {
        case .easy:
            return 0...10
        case .medium:
            return 0...12
        case .hard:
            return 0...20
        }
    }

    private func divisionAnswerRange(for difficulty: Difficulty) -> ClosedRange<Int> {
        switch difficulty {
        case .easy:
            return 0...10
        case .medium:
            return 0...12
        case .hard:
            return 0...20
        }
    }

    private func divisionDivisorRange(for difficulty: Difficulty) -> ClosedRange<Int> {
        switch difficulty {
        case .easy:
            return 1...10
        case .medium:
            return 1...12
        case .hard:
            return 1...20
        }
    }
}
