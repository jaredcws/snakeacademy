import SwiftUI

struct GameOverOverlay: View {
    let reason: String
    let snapshot: GameSnapshot
    var onPlayAgain: () -> Void
    var onMenu: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Text("Game Over")
                .font(.system(size: 46, weight: .black, design: .rounded))
            Text(reason)
                .font(.title3.weight(.bold))
                .foregroundStyle(.secondary)

            HStack(spacing: 14) {
                stat("Final Score", "\(snapshot.score)")
                stat("High Score", "\(max(snapshot.hud.highScore, snapshot.score))")
            }

            HStack(spacing: 12) {
                Button("Play Again", action: onPlayAgain)
                    .buttonStyle(OverlayPrimaryButtonStyle())
                Button("Main Menu", action: onMenu)
                    .buttonStyle(OverlaySecondaryButtonStyle())
            }
        }
        .padding(34)
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.28), lineWidth: 1)
        )
        .padding(30)
    }

    private func stat(_ title: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title.weight(.black))
        }
        .frame(minWidth: 150)
        .padding()
        .background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct OverlayPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.black))
            .foregroundStyle(.black)
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
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.primary.opacity(configuration.isPressed ? 0.18 : 0.08), in: RoundedRectangle(cornerRadius: 14))
    }
}
