//
//  ViewModel.swift
//  ConnectFour
//
//  Created by Andy Bell on 04.11.20.
//

import UIKit

struct GameMove {
    let insertColumn: Int
    let insertColor: UIColor
}

protocol ViewModel {
    
    var gameStateDidUpdate: ((_ gameState: GameState) -> Void) { get set }
    var columnCount: Int { get }
    var rowCount: Int { get }
    
    var playerOneName: String { get }
    var playerTwoName: String { get }
    var playerOneColor: UIColor { get }
    var playerTwoColor: UIColor { get }
    var currentMove: GameMove? { get set }
    
    func requestNewGame()
    func didTapColumn(_ colIdx: Int)
}

class ViewModelDefault: ViewModel {

    var gameStateDidUpdate: ((GameState) -> Void) = { _ in }
    var columnCount: Int = 7
    var rowCount: Int = 6
    var playerOneName: String {
        turnHandler?.player1.name ?? "n/a"
    }
    var playerTwoName: String {
        turnHandler?.player2.name ?? "n/a"
    }
    var playerOneColor: UIColor {
        turnHandler?.playerOneColorForCurrentTurn() ?? UIColor.lightGray
    }
    var playerTwoColor: UIColor {
        turnHandler?.playerTwoColorForCurrentTurn() ?? UIColor.gray
    }
    var currentMove: GameMove? = nil
    
    private var gameManager: GameManager
    private let configLoader: ConfigLoader
    
    private var turnHandler: TurnHandler?

    init(gameManager: GameManager, configLoader: ConfigLoader) {
        self.gameManager = gameManager
        self.configLoader = configLoader
    }
    
    // MARK: public
    func requestNewGame() {
        
        gameManager.setupForNewGame()
        requestNewGameConfig()
    }
    
    func didTapColumn(_ colIdx: Int) {
        
        guard let turnHandler = self.turnHandler,
              gameManager.freeSlotIdxInCol(colIdx) != nil else {
            return
        }
        gameManager.insertIntoCol(colIdx, state: turnHandler.slotStateForCurrentPlayer())
        
        currentMove = GameMove(insertColumn: colIdx, insertColor: turnHandler.currentPlayer.color)
        
        switch gameManager.gameState {
        case .won, .draw:
            break
        default:
            turnHandler.toggleTurn()
        }
        
        gameStateDidUpdate(gameManager.gameState)
    }
    
    // MARK: private
    private func requestNewGameConfig() {
        
        configLoader.loadConfig { [weak self] result in
            let config = (try? result.get()) ?? GameConfig.defaultBackup
            self?.startNewGame(with: config)
        }
    }
    
    private func startNewGame(with config: GameConfig) {
        
        turnHandler = TurnHandler(with: config)
        
        gameStateDidUpdate(gameManager.gameState)
    }
}
