//
//  GameManager.swift
//  ConnectFour
//
//  Created by xxxxx on 28.09.20.
//

import Foundation

enum SlotState: Int {
    case empty = 0
    case player1 = 1
    case player2 = 2
}

struct Slot {
    var state: SlotState = .empty
}

struct GameManager {
    
    private let columnCount: Int
    private let rowCount: Int
    private let winLineCount = 4
    
    private var board = [[Slot]]()
    
    var hasWinner = false
    
    init(columnCount: Int, rowCount: Int) {
        self.columnCount = columnCount
        self.rowCount = rowCount
        
        self.setupForNewGame()
    }
    
    mutating func setupForNewGame() {
        hasWinner = false
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
        
        hasWinner = checkWin(fromCol: colIdx, fromSlot: freeSlotIdx, forState: state)
    }
    
    private func checkWin(fromCol colIdx: Int, fromSlot slotIdx: Int, forState state: SlotState) -> Bool {
        
        if vertLineCount(fromCol: colIdx, fromSlot: slotIdx, forState: state) == winLineCount {
            print("we have a (vertical) winner!!!")
            return true
        }
        
        return false
    }
    
    private func vertLineCount(fromCol colIdx: Int, fromSlot slotIdx: Int, forState state: SlotState) -> Int {
        
        let checkCol = board[colIdx]
        var checkIdx = slotIdx + 1
        var slotCount = 1
        
        while checkIdx < checkCol.count {
            
            let slotState = checkCol[checkIdx].state
            
            guard slotState == state else {
                return slotCount
            }
            slotCount += 1
            checkIdx += 1
        }
        return slotCount
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
