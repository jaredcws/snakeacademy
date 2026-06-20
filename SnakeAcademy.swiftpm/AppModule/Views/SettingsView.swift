import SwiftUI

struct SettingsView: View {
    @State private var difficulty = PersistenceService.shared.selectedDifficulty
    @State private var musicEnabled = PersistenceService.shared.musicEnabled
    @State private var soundEnabled = PersistenceService.shared.soundEnabled

    var body: some View {
        Form {
            Section("Gameplay") {
                Picker("Default Difficulty", selection: $difficulty) {
                    ForEach(Difficulty.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .onChange(of: difficulty) { _, newValue in
                    PersistenceService.shared.selectedDifficulty = newValue
                }
            }

            Section("Audio") {
                Toggle("Music", isOn: $musicEnabled)
                    .onChange(of: musicEnabled) { _, newValue in
                        PersistenceService.shared.musicEnabled = newValue
                    }
                Toggle("Sound Effects", isOn: $soundEnabled)
                    .onChange(of: soundEnabled) { _, newValue in
                        PersistenceService.shared.soundEnabled = newValue
                    }
            }
        }
        .navigationTitle("Settings")
    }
}
