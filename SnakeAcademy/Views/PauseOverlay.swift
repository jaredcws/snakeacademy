import SwiftUI

struct PauseOverlay: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var onResume: () -> Void
    var onRestart: () -> Void
    var onMenu: () -> Void

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        VStack(spacing: isCompact ? 14 : 18) {
            Text("Paused")
                .font(.system(size: isCompact ? 36 : 44, weight: .black, design: .rounded))

            actions
        }
        .padding(isCompact ? 22 : 34)
        .frame(maxWidth: isCompact ? 340 : nil)
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
    }

    @ViewBuilder
    private var actions: some View {
        if isCompact {
            VStack(spacing: 10) {
                Button("Resume", action: onResume)
                    .buttonStyle(OverlayPrimaryButtonStyle())
                Button("Restart", action: onRestart)
                    .buttonStyle(OverlaySecondaryButtonStyle())
                Button("Main Menu", action: onMenu)
                    .buttonStyle(OverlaySecondaryButtonStyle())
            }
        } else {
            HStack(spacing: 12) {
                Button("Resume", action: onResume)
                    .buttonStyle(OverlayPrimaryButtonStyle())
                Button("Restart", action: onRestart)
                    .buttonStyle(OverlaySecondaryButtonStyle())
                Button("Main Menu", action: onMenu)
                    .buttonStyle(OverlaySecondaryButtonStyle())
            }
        }
    }
}
