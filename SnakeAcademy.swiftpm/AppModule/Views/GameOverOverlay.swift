import SwiftUI

struct GameOverOverlay: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let reason: String
    let snapshot: GameSnapshot
    var onPlayAgain: () -> Void
    var onMenu: () -> Void

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        VStack(spacing: isCompact ? 14 : 18) {
            Text("Game Over")
                .font(.system(size: isCompact ? 36 : 46, weight: .black, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(reason)
                .font((isCompact ? Font.headline : Font.title3).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            stats
            actions
        }
        .padding(isCompact ? 22 : 34)
        .frame(maxWidth: isCompact ? 340 : nil)
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.28), lineWidth: 1)
        )
        .padding(isCompact ? 18 : 30)
    }

    @ViewBuilder
    private var stats: some View {
        if isCompact {
            VStack(spacing: 10) {
                stat("Final Score", "\(snapshot.score)")
                stat("High Score", "\(max(snapshot.hud.highScore, snapshot.score))")
            }
        } else {
            HStack(spacing: 14) {
                stat("Final Score", "\(snapshot.score)")
                stat("High Score", "\(max(snapshot.hud.highScore, snapshot.score))")
            }
        }
    }

    @ViewBuilder
    private var actions: some View {
        if isCompact {
            VStack(spacing: 10) {
                Button("Play Again", action: onPlayAgain)
                    .buttonStyle(OverlayPrimaryButtonStyle())
                Button("Main Menu", action: onMenu)
                    .buttonStyle(OverlaySecondaryButtonStyle())
            }
        } else {
            HStack(spacing: 12) {
                Button("Play Again", action: onPlayAgain)
                    .buttonStyle(OverlayPrimaryButtonStyle())
                Button("Main Menu", action: onMenu)
                    .buttonStyle(OverlaySecondaryButtonStyle())
            }
        }
    }

    private func stat(_ title: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            Text(value)
                .font((isCompact ? Font.title2 : Font.title).weight(.black))
        }
        .frame(maxWidth: .infinity, minHeight: isCompact ? 64 : nil)
        .frame(minWidth: isCompact ? 0 : 150)
        .padding(isCompact ? 12 : 16)
        .background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct OverlayPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.black))
            .foregroundStyle(.black)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.green.opacity(configuration.isPressed ? 0.75 : 1), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct OverlaySecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.black))
            .foregroundStyle(.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.primary.opacity(configuration.isPressed ? 0.18 : 0.08), in: RoundedRectangle(cornerRadius: 14))
    }
}
