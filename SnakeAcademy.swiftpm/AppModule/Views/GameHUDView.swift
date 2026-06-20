import SwiftUI

struct GameHUDView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let snapshot: GameSnapshot
    var onPause: () -> Void
    var onResume: () -> Void
    var onRestart: () -> Void
    var onBack: () -> Void
    var onClearWord: () -> Void

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    private var compactColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 96), spacing: 8)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 10 : 14) {
            if isCompact {
                compactHeader
            } else {
                regularHeader
            }

            modeSpecificHUD
        }
        .padding(.horizontal, isCompact ? 12 : 24)
        .padding(.vertical, isCompact ? 10 : 16)
        .background(.regularMaterial)
    }

    private var regularHeader: some View {
        HStack(spacing: 14) {
            titleBlock

            Spacer()

            hudMetric("Score", "\(snapshot.hud.score)")
            hudMetric("High", "\(snapshot.hud.highScore)")
            hudMetric("Length", "\(snapshot.hud.snakeLength)")

            Button(pauseButtonTitle, action: pauseOrResume)
                .buttonStyle(HUDButtonStyle())

            Button("Restart", action: onRestart)
                .buttonStyle(HUDButtonStyle())

            Button("Menu", action: onBack)
                .buttonStyle(HUDButtonStyle())
        }
    }

    private var compactHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                titleBlock
                Spacer()
                Button("Menu", action: onBack)
                    .buttonStyle(HUDButtonStyle())
            }

            LazyVGrid(columns: compactColumns, alignment: .leading, spacing: 8) {
                hudMetric("Score", "\(snapshot.hud.score)")
                hudMetric("High", "\(snapshot.hud.highScore)")
                hudMetric("Length", "\(snapshot.hud.snakeLength)")
            }

            HStack(spacing: 8) {
                Button(pauseButtonTitle, action: pauseOrResume)
                    .buttonStyle(HUDButtonStyle())
                Button("Restart", action: onRestart)
                    .buttonStyle(HUDButtonStyle())
            }
        }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(snapshot.mode.title)
                .font((isCompact ? Font.headline : Font.title2).weight(.black))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(snapshot.difficulty.title)
                .font((isCompact ? Font.caption : Font.subheadline).weight(.bold))
                .foregroundStyle(.secondary)
        }
    }

    private var pauseButtonTitle: String {
        snapshot.status == .paused ? "Resume" : "Pause"
    }

    private func pauseOrResume() {
        if snapshot.status == .paused {
            onResume()
        } else {
            onPause()
        }
    }

    @ViewBuilder
    private var modeSpecificHUD: some View {
        switch snapshot.mode {
        case .classic:
            EmptyView()
        case .word:
            if isCompact {
                LazyVGrid(columns: compactColumns, alignment: .leading, spacing: 8) {
                    hudMetric("Current Word", snapshot.hud.currentWord.isEmpty ? "-" : snapshot.hud.currentWord)
                    hudMetric("Last Word", snapshot.hud.lastCompletedWord.isEmpty ? "-" : snapshot.hud.lastCompletedWord)
                    hudMetric("Best Word", snapshot.hud.bestWord.isEmpty ? "-" : snapshot.hud.bestWord)
                    Button("Clear Word", action: onClearWord)
                        .buttonStyle(HUDButtonStyle())
                }
            } else {
                HStack(spacing: 14) {
                    hudMetric("Current Word", snapshot.hud.currentWord.isEmpty ? "-" : snapshot.hud.currentWord)
                    hudMetric("Last Word", snapshot.hud.lastCompletedWord.isEmpty ? "-" : snapshot.hud.lastCompletedWord)
                    hudMetric("Best Word", snapshot.hud.bestWord.isEmpty ? "-" : snapshot.hud.bestWord)
                    Button("Clear Word", action: onClearWord)
                        .buttonStyle(HUDButtonStyle())
                }
            }
        case .math:
            if isCompact {
                LazyVGrid(columns: compactColumns, alignment: .leading, spacing: 8) {
                    hudMetric("Problem", snapshot.hud.mathProblemText)
                    hudMetric("Mode", snapshot.hud.mathModeTitle)
                    hudMetric("Streak", "\(snapshot.hud.mathStreak)")
                }
            } else {
                HStack(spacing: 14) {
                    hudMetric("Problem", snapshot.hud.mathProblemText)
                    hudMetric("Mode", snapshot.hud.mathModeTitle)
                    hudMetric("Streak", "\(snapshot.hud.mathStreak)")
                }
            }
        }
    }

    private func hudMetric(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased())
                .font(.caption2.weight(.black))
                .foregroundStyle(.secondary)
            Text(value)
                .font((isCompact ? Font.subheadline : Font.headline).weight(.black))
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, isCompact ? 10 : 12)
        .padding(.vertical, isCompact ? 7 : 8)
        .background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 10))
    }
}

private struct HUDButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.bold))
            .foregroundStyle(.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(Color.primary.opacity(configuration.isPressed ? 0.16 : 0.08), in: RoundedRectangle(cornerRadius: 10))
    }
}
