import SwiftUI

struct MathModeSelectionView: View {
    let difficulty: Difficulty

    var body: some View {
        List {
            Section("Choose a math mode") {
                ForEach(MathOperationMode.allCases) { operation in
                    NavigationLink {
                        GameContainerView(mode: .math, difficulty: difficulty, mathMode: operation)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(operation.title)
                                .font(.headline)
                            Text(description(for: operation))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Math Snake")
    }

    private func description(for operation: MathOperationMode) -> String {
        switch operation {
        case .addition:
            return "Practice sums while dodging the walls."
        case .subtraction:
            return "Find non-negative differences."
        case .multiplication:
            return "Choose products from believable distractors."
        case .division:
            return "Only whole-number division problems appear."
        case .mixed:
            return "A rotating mix of all math operations."
        }
    }
}
