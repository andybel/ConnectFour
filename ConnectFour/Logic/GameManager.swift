//
//  GameManager.swift
//  ConnectFour
//
//  Created by xxxxx on 28.09.20.
//

import Foundation

struct GameGrid {
    let columns: Int
    let rows: Int
}

enum SlotState: Int {
    case empty = 0
    case player1 = 1
    case player2 = 2
}

struct Slot {
    var state: SlotState = .empty
}

enum GameState {
    case started, inProgress, won, draw
}

struct GameManager {
    
    let grid: GameGrid
    
    var gameState: GameState = .started
    
    private let winLineCount = 4
    
    private var board = [[Slot]]()
    
    init(grid: GameGrid) {
        self.grid = grid
        
        self.setupForNewGame()
    }
    
    mutating func setupForNewGame() {
        gameState = .started
        board = [[Slot]](repeating: [Slot](repeating: Slot(), count: grid.rows), count: grid.columns)
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
        
        if checkWin(fromCol: colIdx, fromSlot: freeSlotIdx, forState: state) {
            gameState = .won
        } else if checkForDraw() {
            gameState = .draw
        } else {
            gameState = .inProgress
        }
    }
    
    private func checkWin(fromCol colIdx: Int, fromSlot slotIdx: Int, forState state: SlotState) -> Bool {
        
        if vertLineCount(fromCol: colIdx, fromSlot: slotIdx, forState: state) == winLineCount {
            print("we have a (vertical) winner!!!")
            return true
        } else if horzLineCount(fromCol: colIdx, fromSlot: slotIdx, forState: state) == winLineCount {
            print("we have a (horizontal) winner!")
            return true
        } else if leftDiagonalLineCount(fromCol: colIdx, fromSlot: slotIdx, forState: state) == winLineCount {
            print("we have a (left-diagonal) winner!")
            return true
        } else if rightDiagonalLineCount(fromCol: colIdx, fromSlot: slotIdx, forState: state) == winLineCount {
            print("we have a (right-diagonal) winner!")
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
    
    private func horzLineCount(fromCol colIdx: Int, fromSlot slotIdx: Int, forState state: SlotState) -> Int {
    
        var slotCount = 1
        
        // check to left
        if colIdx > 0 {
            var colCheckIdx = colIdx - 1
            
            while colCheckIdx >= 0 {
                
                let leftNeighbourState = board[colCheckIdx][slotIdx].state
                print("<<< check state for col: \(colCheckIdx), row: \(slotIdx) = \(leftNeighbourState)")
                guard leftNeighbourState == state else {
                    break
                }
                slotCount += 1
                colCheckIdx -= 1
            }
        }
        
        // then check to right if winCount not reached
        if colIdx < board.count {
            
            var colCheckIdx = colIdx + 1
            
            while colCheckIdx < board.count {
                
                let rightNeighbourState = board[colCheckIdx][slotIdx].state
                print(">>> check state forcol: \(colCheckIdx), row: \(slotIdx) = \(rightNeighbourState)")
                guard rightNeighbourState == state else {
                    break
                }
                slotCount += 1
                colCheckIdx += 1
            }
        }
        return slotCount
    }
    
    private func leftDiagonalLineCount(fromCol colIdx: Int, fromSlot slotIdx: Int, forState state: SlotState) -> Int {
    
        var checkRowIdx = slotIdx
        var checkColIdx = colIdx
        var slotCount = 1

        // search up and left
        while checkColIdx > 0 && checkRowIdx > 0 {

            checkColIdx -= 1
            checkRowIdx -= 1
            
            let checkState = board[checkColIdx][checkRowIdx].state
            print("<<<^^^ check state for col: \(checkColIdx), row: \(checkRowIdx) = \(checkState)")
            guard checkState == state else {
                break
            }
            slotCount += 1
        }

        // search down and right
        checkRowIdx = slotIdx
        checkColIdx = colIdx
        while checkColIdx < board.count - 1 && checkRowIdx < grid.rows - 1 {

            checkColIdx += 1
            checkRowIdx += 1
            
            print("!!! check state for col: \(checkColIdx), row: \(checkRowIdx)")
            let checkState = board[checkColIdx][checkRowIdx].state
            print("vvv>>> check state for col: \(checkColIdx), row: \(checkRowIdx) = \(checkState)")
            guard checkState == state else {
                break
            }
            slotCount += 1
        }
    
        return slotCount
    }
    
    private func rightDiagonalLineCount(fromCol colIdx: Int, fromSlot slotIdx: Int, forState state: SlotState) -> Int {
    
        var checkRowIdx = slotIdx
        var checkColIdx = colIdx
        var slotCount = 1
        
        // search up and right
        while checkColIdx < grid.columns - 1 && checkRowIdx > 0 {

            checkColIdx += 1
            checkRowIdx -= 1
            
            let checkState = board[checkColIdx][checkRowIdx].state
            print("^^^>>> check state for col: \(checkColIdx), row: \(checkRowIdx) = \(checkState)")
            guard checkState == state else {
                break
            }
            slotCount += 1
        }
        
        // search down and left
        checkRowIdx = slotIdx
        checkColIdx = colIdx
        while checkColIdx > 0 && checkRowIdx < grid.rows - 1 {

            checkColIdx -= 1
            checkRowIdx += 1
            
            let checkState = board[checkColIdx][checkRowIdx].state
            print("vvv<<< check state for col: \(checkColIdx), row: \(checkRowIdx) = \(checkState)")
            guard checkState == state else {
                break
            }
            slotCount += 1
        }
        
        return slotCount
    }
    
    private func checkForDraw() -> Bool {
        
        for col in board {
            for row in col {
                if row.state == .empty {
                    return false
                }
            }
        }
        return true
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
