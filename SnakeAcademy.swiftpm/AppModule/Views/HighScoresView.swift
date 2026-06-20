import SwiftUI

struct HighScoresView: View {
    private let persistence = PersistenceService.shared

    var body: some View {
        List {
            Section("High Scores") {
                scoreRow("Classic Snake", persistence.highScore(for: .classic))
                scoreRow("Word Snake", persistence.highScore(for: .word))
                scoreRow("Math Snake", persistence.highScore(for: .math))
            }

            Section("Milestones") {
                textRow("Best Word", persistence.bestWord.isEmpty ? "-" : persistence.bestWord)
                scoreRow("Longest Snake", persistence.longestSnake)
                scoreRow("Best Math Streak", persistence.mathBestStreak())
                scoreRow("Games Played", persistence.gamesPlayed)
                scoreRow("Total Score", persistence.totalScore)
                scoreRow("Words Completed", persistence.wordsCompleted)
                scoreRow("Math Problems Solved", persistence.mathProblemsSolved)
            }
        }
        .navigationTitle("High Scores")
    }

    private func scoreRow(_ title: String, _ value: Int) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value)")
                .font(.headline.weight(.black))
        }
    }

    private func textRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(.headline.weight(.black))
        }
    }
}
