import SwiftUI

struct PauseOverlay: View {
    var onResume: () -> Void
    var onRestart: () -> Void
    var onMenu: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Text("Paused")
                .font(.system(size: 44, weight: .black, design: .rounded))

            HStack(spacing: 12) {
                Button("Resume", action: onResume)
                    .buttonStyle(OverlayPrimaryButtonStyle())
                Button("Restart", action: onRestart)
                    .buttonStyle(OverlaySecondaryButtonStyle())
                Button("Main Menu", action: onMenu)
                    .buttonStyle(OverlaySecondaryButtonStyle())
            }
        }
        .padding(34)
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
    }
}
