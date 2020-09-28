//
//  GameManager.swift
//  ConnectFour
//
//  Created by Andy Bell on 28.09.20.
//

import Foundation

enum SlotState: Int {
    case empty = 0
    case red = 1
    case blue = 2
}

struct Slot {
    var state: SlotState = .empty
}

struct GameManager {
    
    private let columnCount: Int
    private let rowCount: Int
    
    private var board = [[Slot]]()
    
    init(columnCount: Int, rowCount: Int) {
        self.columnCount = columnCount
        self.rowCount = rowCount
        
        self.setupForNewGame()
    }
    
    mutating func setupForNewGame() {
        board = [[Slot]](repeating: [Slot](repeating: Slot(), count: rowCount), count: columnCount)
    }
    
    func freeSlotIdxInCol(_ colIdx: Int) -> Int? {
        
        for i in stride(from: board[colIdx].count - 1, through: 0, by: -1) {
            let slot = board[colIdx][i]
            if slot.state == .empty {
                print("Col \(colIdx) slot empty at idx: \(i)")
                return i
            }
        }
        return nil
    }
    
    mutating func insertIntoCol(_ colIdx: Int, state: SlotState) {
        
        guard let freeSlotIdx = freeSlotIdxInCol(colIdx) else {
            return
        }
        board[colIdx][freeSlotIdx].state = state
    }
}

extension GameManager {
    
    func logCurrentState() {
        
        var colStr = "\ncolumn:\t||"
        for i in 0..<board.count {
            colStr += "\t\(i)\t|"
        }
        print(colStr + "|\n")
        
        let rowCount = 6
        for i in 0..<rowCount {
            var rowStr = "row:\(i)\t||"
            board.forEach { col in
                rowStr += "\(col[i].state)\t|"
            }
            print(rowStr + "|")
        }
    }
}
