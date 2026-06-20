import SpriteKit
import UIKit

@MainActor
final class SnakeGameScene: SKScene {
    private let engine: SnakeGameEngine
    private let coordinator: SnakeSceneCoordinator
    private var lastMoveTime: TimeInterval = 0

    init(engine: SnakeGameEngine) {
        self.engine = engine
        self.coordinator = SnakeSceneCoordinator(engine: engine)
        super.init(size: CGSize(width: 900, height: 700))
        scaleMode = .resizeFill
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = false
        render(snapshot: engine.snapshot)
    }

    override func update(_ currentTime: TimeInterval) {
        guard engine.snapshot.status == .running else {
            render(snapshot: engine.snapshot)
            return
        }

        if currentTime - lastMoveTime >= engine.effectiveTickInterval {
            engine.step()
            lastMoveTime = currentTime
            render(snapshot: engine.snapshot)
        }
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            guard let key = press.key else {
                continue
            }

            switch key.keyCode {
            case .keyboardUpArrow:
                coordinator.move(.up)
            case .keyboardDownArrow:
                coordinator.move(.down)
            case .keyboardLeftArrow:
                coordinator.move(.left)
            case .keyboardRightArrow:
                coordinator.move(.right)
            default:
                break
            }
        }
    }

    func render(snapshot: GameSnapshot) {
        removeAllChildren()

        guard snapshot.configuration.columns > 0, snapshot.configuration.rows > 0 else {
            return
        }

        let board = boardRect(for: snapshot.configuration)
        let boardNode = SKShapeNode(rect: board, cornerRadius: 28)
        boardNode.fillColor = UIColor(red: 0.06, green: 0.10, blue: 0.13, alpha: 1)
        boardNode.strokeColor = UIColor(red: 0.16, green: 0.25, blue: 0.29, alpha: 1)
        boardNode.lineWidth = 3
        addChild(boardNode)

        drawGrid(in: board, configuration: snapshot.configuration)
        drawCollectibles(snapshot.collectibles, board: board, configuration: snapshot.configuration)
        drawSnake(snapshot.snake, board: board, configuration: snapshot.configuration)
    }

    private func boardRect(for configuration: GameConfiguration) -> CGRect {
        let side = min(size.width, size.height) * 0.94
        return CGRect(
            x: (size.width - side) / 2,
            y: (size.height - side) / 2,
            width: side,
            height: side
        )
    }

    private func drawGrid(in board: CGRect, configuration: GameConfiguration) {
        let path = CGMutablePath()
        let cell = board.width / CGFloat(configuration.columns)

        for index in 0...configuration.columns {
            let x = board.minX + CGFloat(index) * cell
            path.move(to: CGPoint(x: x, y: board.minY))
            path.addLine(to: CGPoint(x: x, y: board.maxY))
        }

        for index in 0...configuration.rows {
            let y = board.minY + CGFloat(index) * cell
            path.move(to: CGPoint(x: board.minX, y: y))
            path.addLine(to: CGPoint(x: board.maxX, y: y))
        }

        let node = SKShapeNode(path: path)
        node.strokeColor = UIColor.white.withAlphaComponent(0.06)
        node.lineWidth = 1
        addChild(node)
    }

    private func drawSnake(_ snake: [GridPoint], board: CGRect, configuration: GameConfiguration) {
        for (index, point) in snake.enumerated() {
            let rect = rect(for: point, board: board, configuration: configuration).insetBy(dx: 1.5, dy: 1.5)
            let node = SKShapeNode(rect: rect, cornerRadius: rect.width * 0.25)
            node.fillColor = index == 0
                ? UIColor(red: 0.60, green: 1.00, blue: 0.30, alpha: 1)
                : UIColor(red: 0.23, green: 0.78, blue: 0.42, alpha: 1)
            node.strokeColor = UIColor.white.withAlphaComponent(index == 0 ? 0.45 : 0.20)
            node.lineWidth = index == 0 ? 2 : 1
            addChild(node)
        }
    }

    private func drawCollectibles(_ collectibles: [Collectible], board: CGRect, configuration: GameConfiguration) {
        for collectible in collectibles {
            let cellRect = rect(for: collectible.position, board: board, configuration: configuration).insetBy(dx: 2, dy: 2)

            switch collectible.kind {
            case .food:
                let node = SKShapeNode(ellipseIn: cellRect.insetBy(dx: cellRect.width * 0.12, dy: cellRect.height * 0.12))
                node.fillColor = UIColor(red: 1.00, green: 0.31, blue: 0.38, alpha: 1)
                node.strokeColor = UIColor.white.withAlphaComponent(0.55)
                node.lineWidth = 2
                node.run(.repeatForever(.sequence([
                    .scale(to: 1.12, duration: 0.35),
                    .scale(to: 1.00, duration: 0.35)
                ])))
                addChild(node)
            case let .letter(letter):
                drawTile(text: String(letter), rect: cellRect, fill: UIColor(red: 0.20, green: 0.58, blue: 1.00, alpha: 1))
            case let .number(value, isCorrectAnswer):
                let fill = isCorrectAnswer
                    ? UIColor(red: 0.95, green: 0.76, blue: 0.18, alpha: 1)
                    : UIColor(red: 0.55, green: 0.50, blue: 0.92, alpha: 1)
                drawTile(text: "\(value)", rect: cellRect, fill: fill)
            }
        }
    }

    private func drawTile(text: String, rect: CGRect, fill: UIColor) {
        let tile = SKShapeNode(rect: rect, cornerRadius: rect.width * 0.22)
        tile.fillColor = fill
        tile.strokeColor = UIColor.white.withAlphaComponent(0.65)
        tile.lineWidth = 2
        addChild(tile)

        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = text
        label.fontColor = .white
        label.fontSize = max(11, rect.height * 0.42)
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: rect.midX, y: rect.midY - 1)
        addChild(label)
    }

    private func rect(for point: GridPoint, board: CGRect, configuration: GameConfiguration) -> CGRect {
        let cell = board.width / CGFloat(configuration.columns)
        return CGRect(
            x: board.minX + CGFloat(point.x) * cell,
            y: board.minY + CGFloat(point.y) * cell,
            width: cell,
            height: cell
        )
    }
}
