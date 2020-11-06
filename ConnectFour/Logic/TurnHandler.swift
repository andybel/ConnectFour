//
//  TurnHandler.swift
//  ConnectFour
//
//  Created by xxxxxxx on 28.09.20.
//

import UIKit

final class TurnHandler {
    
    let player1: Player
    let player2: Player
    
    var currentPlayer: Player
    
    init(with config: GameConfig) {
        
        let color1 = UIColor.fromHexString(config.color1) ?? UIColor.red
        let color2 = UIColor.fromHexString(config.color2) ?? UIColor.blue
        
        self.player1 = Player(name: config.name1, color: color1)
        self.player2 = Player(name: config.name2, color: color2)
        
        self.currentPlayer = Bool.random() ? player1 : player2
    }
    
    func toggleTurn() {
        currentPlayer = currentPlayer == player1 ? player2 : player1
    }
    
    func slotStateForCurrentPlayer() -> SlotState {
        return currentPlayer == player1 ? .player1 : .player2
    }
    
    func playerOneColorForCurrentTurn() -> UIColor {
        return currentPlayer == player1 ? player1.color : UIColor.clear
    }
    
    func playerTwoColorForCurrentTurn() -> UIColor {
        return currentPlayer == player2 ? player2.color : UIColor.clear
    }
}
