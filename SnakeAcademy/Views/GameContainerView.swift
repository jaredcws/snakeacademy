import SpriteKit
import SwiftUI
import UIKit

struct GameContainerView: View {
    let mode: GameMode
    let difficulty: Difficulty
    let mathMode: MathOperationMode?

    @Environment(\.dismiss) private var dismiss
    @StateObject private var engine: SnakeGameEngine
    @State private var scene: SnakeGameScene

    init(mode: GameMode, difficulty: Difficulty, mathMode: MathOperationMode? = nil) {
        let engine = SnakeGameEngine()
        self.mode = mode
        self.difficulty = difficulty
        self.mathMode = mathMode
        _engine = StateObject(wrappedValue: engine)
        _scene = State(initialValue: SnakeGameScene(engine: engine))
    }

    var body: some View {
        VStack(spacing: 0) {
            GameHUDView(
                snapshot: engine.snapshot,
                onPause: { engine.pause() },
                onResume: { engine.resume() },
                onRestart: { engine.restart() },
                onBack: { dismiss() },
                onClearWord: { engine.clearWordTray() }
            )

            ZStack {
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .background(Color(red: 0.02, green: 0.05, blue: 0.07))
                    .gesture(swipeGesture)
                    .overlay(KeyboardInputView { direction in
                        engine.updateDirection(direction)
                    }
                    .frame(width: 1, height: 1))

                if engine.snapshot.status == .paused {
                    PauseOverlay(onResume: { engine.resume() }, onRestart: { engine.restart() }, onMenu: { dismiss() })
                }

                if case let .gameOver(reason) = engine.snapshot.status {
                    GameOverOverlay(
                        reason: reason,
                        snapshot: engine.snapshot,
                        onPlayAgain: { engine.restart() },
                        onMenu: { dismiss() }
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(red: 0.02, green: 0.05, blue: 0.07).ignoresSafeArea())
        .onAppear {
            if engine.snapshot.status == .ready {
                engine.startNewGame(mode: mode, difficulty: difficulty, mathMode: mathMode)
            }
        }
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 24)
            .onEnded { value in
                let dx = value.translation.width
                let dy = value.translation.height

                if abs(dx) > abs(dy) {
                    engine.updateDirection(dx > 0 ? .right : .left)
                } else {
                    engine.updateDirection(dy > 0 ? .down : .up)
                }
            }
    }
}

private struct KeyboardInputView: UIViewRepresentable {
    var onDirection: (Direction) -> Void

    func makeUIView(context: Context) -> KeyCaptureView {
        let view = KeyCaptureView()
        view.onDirection = onDirection
        DispatchQueue.main.async {
            view.becomeFirstResponder()
        }
        return view
    }

    func updateUIView(_ uiView: KeyCaptureView, context: Context) {
        uiView.onDirection = onDirection
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }

    final class KeyCaptureView: UIView {
        var onDirection: ((Direction) -> Void)?

        override var canBecomeFirstResponder: Bool {
            true
        }

        override var keyCommands: [UIKeyCommand]? {
            [
                UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(up)),
                UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(down)),
                UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(left)),
                UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(right))
            ]
        }

        @objc private func up() {
            onDirection?(.up)
        }

        @objc private func down() {
            onDirection?(.down)
        }

        @objc private func left() {
            onDirection?(.left)
        }

        @objc private func right() {
            onDirection?(.right)
        }
    }
}
