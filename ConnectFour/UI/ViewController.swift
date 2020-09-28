//
//  ViewController.swift
//  ConnectFour
//
//  Created by xxxxxxx on 28.09.20.
//

import UIKit

class ViewController: UIViewController {

    private let columnsStack = UIStackView(frame: .zero)
    private let columnCount = 7
    private let rowCount = 6
    private let sidePadding: CGFloat = 200.0
    private let p1Label = PlayerLabel(frame: .zero)
    private let p2Label = PlayerLabel(frame: .zero)
    
    private var gameManager: GameManager!
    private var turnHandler: TurnHandler?
    private var columns = [ColumnView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameManager = GameManager(columnCount: columnCount, rowCount: rowCount)
        configureMainColumnsStack(cols: columnCount, rows: rowCount)
        configurePlayerLabels()
        
        requestNewGameConfig()
    }
    
    private func requestNewGameConfig() {
        
        ConfigLoader().loadConfig { [weak self] result in
            
            switch result {
            case .success(let config):
                DispatchQueue.main.async {
                    self?.startNewGame(with: config)
                }
            case .failure(let error):
                print("Config load error: \(error.localizedDescription)")
            }
        }
    }
    
    private func startNewGame(with config: GameConfig) {
        
        gameManager.setupForNewGame()
        turnHandler = TurnHandler(with: config)
        
        if let turnHandler = self.turnHandler {
            p1Label.text = "Player 1:\n\(turnHandler.player1.name)"
            p2Label.text = "Player 2:\n\(turnHandler.player2.name)"
            setPlayerLabelColors()
        }
    }
    
    private func setPlayerLabelColors() {
        guard let turnHandler = self.turnHandler  else {
            return
        }
        p1Label.backgroundColor = turnHandler.playerOneColorForCurrentTurn()
        p2Label.backgroundColor = turnHandler.playerTwoColorForCurrentTurn()
    }
    
    private func configurePlayerLabels() {
        
        p1Label.text = "Player 1"
        p1Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(p1Label)
        
        NSLayoutConstraint.activate([
            p1Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            p1Label.trailingAnchor.constraint(equalTo: columnsStack.leadingAnchor, constant: -10),
            p1Label.centerYAnchor.constraint(equalTo: columnsStack.centerYAnchor),
            p1Label.heightAnchor.constraint(equalTo: columnsStack.heightAnchor)
        ])
        
        p2Label.text = "Player 2"
        p2Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(p2Label)
        
        NSLayoutConstraint.activate([
            p2Label.leadingAnchor.constraint(equalTo: columnsStack.trailingAnchor, constant: 10),
            p2Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            p2Label.centerYAnchor.constraint(equalTo: columnsStack.centerYAnchor),
            p2Label.heightAnchor.constraint(equalTo: columnsStack.heightAnchor)
        ])
    }
    
    private func configureMainColumnsStack(cols: Int, rows: Int) {
        
        let aspectRatio = CGFloat(cols) / CGFloat(rows)
        
        columnsStack.clipsToBounds = true
        columnsStack.layer.cornerRadius = 20.0
        columnsStack.axis = .horizontal
        columnsStack.distribution = .fillEqually
        columnsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(columnsStack)
        
        NSLayoutConstraint.activate([
            columnsStack.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -sidePadding),
            columnsStack.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: aspectRatio, constant: -sidePadding),
            columnsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            columnsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        for i in 0..<cols {
            
            let column = ColumnView(frame: .zero)
            let customGray = UIColor.fromHexString("#f0f0f0") ?? UIColor.lightGray
            column.backgroundColor = i % 2 == 0 ? customGray : UIColor.white
            column.tag = i
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(columnTapAction(_:)))
            column.addGestureRecognizer(tapGesture)
            
            columnsStack.addArrangedSubview(column)
            columns.append(column)
        }
    }
    
    private func addDiscToColumn(_ coldIdx: Int, withColor color: UIColor) {
        
        let column = columns[coldIdx]
        column.addDiscWithColor(color)
    }
    
    private func clearGameUI() {
        
        p1Label.text = ""
        p1Label.backgroundColor = .clear
        p2Label.text = ""
        p2Label.backgroundColor = .clear
        
        for col in columnsStack.subviews where col.isKind(of: ColumnView.self) {
            guard let colView = col as? ColumnView else {
                return
            }
            colView.clearDiscs()
        }
    }
    
    private func displayWin(for player: Player) {
        
        let alert = UIAlertController(title: "Four In A Row!", message: "\(player.name) has won the game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: resetForNewGame))
        present(alert, animated: true, completion: nil)
    }
    
    private func displayForDraw() {
        
        let alert = UIAlertController(title: "It's A Draw!", message: "The slots are full. Let's play another one...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: resetForNewGame))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetForNewGame(_ sender: Any) {
        clearGameUI()
        gameManager.setupForNewGame()
        requestNewGameConfig()
    }
    
    @IBAction func columnTapAction(_ sender: UITapGestureRecognizer) {
        
        guard let tapColumn = sender.view as? ColumnView,
              let turnHandler = self.turnHandler,
              gameManager.freeSlotIdxInCol(tapColumn.tag) != nil else {
            return
        }
        gameManager.insertIntoCol(tapColumn.tag, state: turnHandler.slotStateForCurrentPlayer())
        addDiscToColumn(tapColumn.tag, withColor: turnHandler.currentPlayer.color)
        
        switch gameManager.gameState {
        case .won:
            displayWin(for: turnHandler.currentPlayer)
        case .draw:
            displayForDraw()
        default:
            self.turnHandler?.toggleTurn()
            setPlayerLabelColors()
        }
    }
}
