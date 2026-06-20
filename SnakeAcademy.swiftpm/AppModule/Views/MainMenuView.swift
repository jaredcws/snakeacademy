import SwiftUI

struct MainMenuView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var difficulty = PersistenceService.shared.selectedDifficulty

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.04, green: 0.10, blue: 0.12), Color(red: 0.09, green: 0.28, blue: 0.22)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: isCompact ? 18 : 26) {
                        VStack(spacing: 10) {
                            Text("Snake Academy")
                                .font(.system(size: isCompact ? 40 : 58, weight: .black, design: .rounded))
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.8)
                            Text("Fast snake action with word and math challenges.")
                                .font((isCompact ? Font.body : Font.title3).weight(.semibold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white.opacity(0.78))
                        }
                        .foregroundStyle(.white)

                        Picker("Difficulty", selection: $difficulty) {
                            ForEach(Difficulty.allCases) { option in
                                Text(option.title).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 520)
                        .onChange(of: difficulty) { _, newValue in
                            PersistenceService.shared.selectedDifficulty = newValue
                        }

                        VStack(spacing: isCompact ? 12 : 16) {
                            NavigationLink {
                                GameContainerView(mode: .classic, difficulty: difficulty)
                            } label: {
                                menuButton(title: "Classic Snake", subtitle: "Eat food, grow, and survive.")
                            }

                            NavigationLink {
                                GameContainerView(mode: .word, difficulty: difficulty)
                            } label: {
                                menuButton(title: "Word Snake", subtitle: "Collect letters and complete words.")
                            }

                            NavigationLink {
                                MathModeSelectionView(difficulty: difficulty)
                            } label: {
                                menuButton(title: "Math Snake", subtitle: "Solve problems by eating answers.")
                            }

                            secondaryLinks
                        }
                        .frame(maxWidth: 620)
                    }
                    .padding(.horizontal, isCompact ? 18 : 40)
                    .padding(.vertical, isCompact ? 24 : 40)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    private var secondaryLinks: some View {
        if isCompact {
            VStack(spacing: 12) {
                highScoresLink
                settingsLink
            }
        } else {
            HStack(spacing: 16) {
                highScoresLink
                settingsLink
            }
        }
    }

    private var highScoresLink: some View {
        NavigationLink("High Scores") {
            HighScoresView()
        }
        .buttonStyle(SecondaryMenuButtonStyle())
    }

    private var settingsLink: some View {
        NavigationLink("Settings") {
            SettingsView()
        }
        .buttonStyle(SecondaryMenuButtonStyle())
    }

    private func menuButton(title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font((isCompact ? Font.title3 : Font.title2).weight(.black))
                Text(subtitle)
                    .font((isCompact ? Font.callout : Font.body).weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font((isCompact ? Font.headline : Font.title2).weight(.bold))
        }
        .foregroundStyle(.white)
        .padding(isCompact ? 18 : 24)
        .background(Color.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
    }
}

private struct SecondaryMenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.white.opacity(configuration.isPressed ? 0.22 : 0.12), in: RoundedRectangle(cornerRadius: 16))
    }
}
