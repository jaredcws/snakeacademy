import SwiftUI

struct MainMenuView: View {
    @State private var difficulty = PersistenceService.shared.selectedDifficulty

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.04, green: 0.10, blue: 0.12), Color(red: 0.09, green: 0.28, blue: 0.22)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 26) {
                    VStack(spacing: 10) {
                        Text("Snake Academy")
                            .font(.system(size: 58, weight: .black, design: .rounded))
                        Text("Fast snake action with word and math challenges.")
                            .font(.title3.weight(.semibold))
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

                    VStack(spacing: 16) {
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

                        HStack(spacing: 16) {
                            NavigationLink("High Scores") {
                                HighScoresView()
                            }
                            .buttonStyle(SecondaryMenuButtonStyle())

                            NavigationLink("Settings") {
                                SettingsView()
                            }
                            .buttonStyle(SecondaryMenuButtonStyle())
                        }
                    }
                    .frame(maxWidth: 620)
                }
                .padding(40)
            }
        }
        .navigationViewStyle(.stack)
    }

    private func menuButton(title: String, subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title2.weight(.black))
                Text(subtitle)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.title2.weight(.bold))
        }
        .foregroundStyle(.white)
        .padding(24)
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
