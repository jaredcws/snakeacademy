# Snake Academy

Snake Academy is a native iOS/iPadOS SwiftUI and SpriteKit game with three playable Snake modes:

- Classic Snake: eat food, grow, score points, and avoid walls or your own body.
- Word Snake: collect letters, complete valid words, score by word length, and clear bad trays.
- Math Snake: solve addition, subtraction, multiplication, division, or mixed problems by eating the correct number tile.

## Open in Xcode

1. Open `SnakeAcademy.xcodeproj`.
2. Select the `SnakeAcademy` scheme.
3. Choose an iPhone or iPad simulator running iOS/iPadOS 17.0 or newer, or connect a physical iPhone or iPad.
4. Press Run.

## Open in Swift Playgrounds

1. Open `SnakeAcademy.swiftpm` in Swift Playgrounds on iPad or Mac.
2. Press Run.

The `.swiftpm` package is included for Swift Playgrounds. The `.xcodeproj` remains available for Xcode.

## Controls

- Swipe up, down, left, or right on the board to steer.
- Hardware keyboard arrow keys also steer in the simulator.
- Use Pause, Restart, and Menu from the top HUD.

## Game Modes

Classic Snake starts with four segments. Each food item gives 1 point and 1 growth.

Word Snake keeps 12 letter tiles on the board. Completed words of at least three letters score from 10 to 100 points based on length, and the snake grows by the completed word length.

Math Snake keeps 10 number tiles on the board. Correct answers give 10 points and 2 growth. Wrong answers subtract 5 points, keep the same problem, and replace the wrong tile.

## Persistence

The first version uses `UserDefaults` for high scores, best word, longest snake, game totals, selected difficulty, and audio settings.

## Known Assumptions

- Gameplay art is built from SpriteKit shapes and labels, so the game does not require external image assets.
- The local dictionary is embedded in `WordValidator.swift`.
- Audio controls are persisted, but audio playback is intentionally not required for the MVP.
- The project targets iOS/iPadOS 17.0 and supports both iPhone and iPad.

## Future Enhancements

- Skins and unlockable boards
- Campaign lessons
- Larger dictionary resource
- Grade-level math settings
- Sound effects and background music
- App icon set
- Online leaderboards
- Classroom mode
