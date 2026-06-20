import SwiftUI

struct GameHUDView: View {
    let snapshot: GameSnapshot
    var onPause: () -> Void
    var onResume: () -> Void
    var onRestart: () -> Void
    var onBack: () -> Void
    var onClearWord: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(snapshot.mode.title)
                        .font(.title2.weight(.black))
                    Text(snapshot.difficulty.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                hudMetric("Score", "\(snapshot.hud.score)")
                hudMetric("High", "\(snapshot.hud.highScore)")
                hudMetric("Length", "\(snapshot.hud.snakeLength)")

                Button(snapshot.status == .paused ? "Resume" : "Pause") {
                    if snapshot.status == .paused {
                        onResume()
                    } else {
                        onPause()
                    }
                }
                .buttonStyle(HUDButtonStyle())

                Button("Restart", action: onRestart)
                    .buttonStyle(HUDButtonStyle())

                Button("Menu", action: onBack)
                    .buttonStyle(HUDButtonStyle())
            }

            modeSpecificHUD
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(.regularMaterial)
    }

    @ViewBuilder
    private var modeSpecificHUD: some View {
        switch snapshot.mode {
        case .classic:
            EmptyView()
        case .word:
            HStack(spacing: 14) {
                hudMetric("Current Word", snapshot.hud.currentWord.isEmpty ? "-" : snapshot.hud.currentWord)
                hudMetric("Last Word", snapshot.hud.lastCompletedWord.isEmpty ? "-" : snapshot.hud.lastCompletedWord)
                hudMetric("Best Word", snapshot.hud.bestWord.isEmpty ? "-" : snapshot.hud.bestWord)
                Button("Clear Word", action: onClearWord)
                    .buttonStyle(HUDButtonStyle())
            }
        case .math:
            HStack(spacing: 14) {
                hudMetric("Problem", snapshot.hud.mathProblemText)
                hudMetric("Mode", snapshot.hud.mathModeTitle)
                hudMetric("Streak", "\(snapshot.hud.mathStreak)")
            }
        }
    }

    private func hudMetric(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased())
                .font(.caption2.weight(.black))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline.weight(.black))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 10))
    }
}

private struct HUDButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.bold))
            .foregroundStyle(.primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.primary.opacity(configuration.isPressed ? 0.16 : 0.08), in: RoundedRectangle(cornerRadius: 10))
    }
}
