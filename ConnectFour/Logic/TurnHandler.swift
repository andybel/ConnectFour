//
//  TurnHandler.swift
//  ConnectFour
//
//  Created by Andy Bell on 28.09.20.
//

import UIKit

struct TurnHandler {
    
    let player1: Player
    let player2: Player
    
    var currentPlayer: Player
    
    init(with config: GameConfig) {
        
        let color1 = UIColor.fromHexString(config.color1) ?? UIColor.red
        let color2 = UIColor.fromHexString(config.color2) ?? UIColor.blue
        
        self.player1 = Player(name: config.name1, color: color1)
        self.player2 = Player(name: config.name2, color: color2)
        
        if let startingPlayer = [player1, player2].randomElement() {
            self.currentPlayer = startingPlayer
        } else {
            self.currentPlayer = player1
        }
    }
    
    mutating func toggleTurn() {
        currentPlayer = currentPlayer == player1 ? player2 : player1
        print("toggle player to: \(currentPlayer)")
    }
    
    func slotStateForCurrentPlayer() -> SlotState {
        return currentPlayer == player1 ? .player2 : .player1
    }
    
    func playerOneColorForCurrentTurn() -> UIColor {
        return currentPlayer == player1 ? player1.color : UIColor.clear
    }
    
    func playerTwoColorForCurrentTurn() -> UIColor {
        return currentPlayer == player2 ? player2.color : UIColor.clear
    }
}
