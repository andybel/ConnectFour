//
//  GameManagerTests.swift
//  ConnectFourTests
//
//  Created by xxxxxxx on 28.09.20.
//

import XCTest
@testable import ConnectFour

class GameManagerTests: XCTestCase {

    private var sut: GameManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = GameManager(grid: GameGrid(columns: 7, rows: 6))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_GameManagerReportsExpectedFreeSlots_whenInitialised() {
        
        XCTAssertNotNil(sut.freeSlotIdxInCol(0), "Column 0 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(1), "Column 1 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(2), "Column 2 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(3), "Column 3 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(4), "Column 4 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(5), "Column 5 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(6), "Column 6 should have free slots after init")
    }
    
    func test_GameMangerReturnExpectedSlotIdx_afterSlotInsertion() {
        
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(0, state: .player1)

        let nextFreeIdx = sut.freeSlotIdxInCol(0)
        XCTAssertNotNil(nextFreeIdx, "next free slot idx should not be nil after 3 insertions")
        XCTAssertEqual(nextFreeIdx, 1, "next free slot idx should be 1 after 4 insertions")
        
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(0, state: .player1)
        let idxForFullColumn = sut.freeSlotIdxInCol(0)
        XCTAssertNil(idxForFullColumn, "slot idx should be nil after 4 insertions")
    }
    
    func test_GameManagerReportsWin_afterVerticalItemsInserted() {
    
        XCTAssertEqual(sut.gameState, GameState.started, "gameState should equal 'started' after init")
        
        sut.insertIntoCol(0, state: .player1)
        
        XCTAssertEqual(sut.gameState, GameState.inProgress, "gameState should equal 'inProgress' after item insertion")
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(0, state: .player1)
        XCTAssertEqual(sut.gameState, GameState.won, "gameState should equal 'won' after 4 vertical insertions of the same state")
        
        sut.setupForNewGame()
        XCTAssertEqual(sut.gameState, GameState.started, "gameState should equal 'started' after game reset")
    }
    
    func test_GameManagerReportsWin_afterHorizontalItemsInserted() {
    
        sut.insertIntoCol(3, state: .player2)
        sut.insertIntoCol(4, state: .player2)
        sut.insertIntoCol(5, state: .player2)
        sut.insertIntoCol(6, state: .player2)
        XCTAssertEqual(sut.gameState, GameState.won, "gameState should equal 'won' after 4 horizontal insertions of the same state")
        
        sut.setupForNewGame()
        XCTAssertEqual(sut.gameState, GameState.started, "gameState should equal 'started' after init")
        
        sut.insertIntoCol(0, state: .player2)
        sut.insertIntoCol(1, state: .player1)
        sut.insertIntoCol(2, state: .player2)
        sut.insertIntoCol(3, state: .player1)
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(1, state: .player1)
        sut.insertIntoCol(2, state: .player1)
        sut.insertIntoCol(3, state: .player1)
        XCTAssertEqual(sut.gameState, GameState.won, "gameState should equal 'won' after 4 horizontal insertions of the same state")
    }
    
    func test_GameManagerReportsWin_afterLeftDiagonalItemsInserted() {
    
        sut.insertIntoCol(3, state: .player2)
        sut.insertIntoCol(3, state: .player1)
        sut.insertIntoCol(3, state: .player2)
        sut.insertIntoCol(3, state: .player1)
        sut.insertIntoCol(4, state: .player2)
        sut.insertIntoCol(4, state: .player1)
        sut.insertIntoCol(4, state: .player1)
        sut.insertIntoCol(5, state: .player2)
        sut.insertIntoCol(5, state: .player1)
        
        XCTAssertEqual(sut.gameState, GameState.inProgress, "gameState should equal 'inProgress' when only 3 left-diagonal insertions of the same state")
        sut.insertIntoCol(6, state: .player2)
        
        XCTAssertEqual(sut.gameState, GameState.won, "gameState should equal 'won' after 4 left-diagonal insertions of the same state")
    }
    
    func test_GameManagerReportsWin_afterRightDiagonalItemsInserted() {
        
        sut.insertIntoCol(0, state: .player2)
        sut.insertIntoCol(1, state: .player1)
        sut.insertIntoCol(2, state: .player2)
        sut.insertIntoCol(3, state: .player1)
        sut.insertIntoCol(1, state: .player2)
        sut.insertIntoCol(2, state: .player1)
        sut.insertIntoCol(3, state: .player1)
        sut.insertIntoCol(2, state: .player2)
        sut.insertIntoCol(3, state: .player1)

        XCTAssertEqual(sut.gameState, GameState.inProgress, "gameState should equal 'inProgress' when only 3 right-diagonal insertions of the same state")
        sut.insertIntoCol(3, state: .player2)

        XCTAssertEqual(sut.gameState, GameState.won, "gameState should equal 'won' after 4 right-diagonal insertions of the same state")
    }
    
    func test_GameManagerReportsDraw_whenAllSlotsAreFilled() {
        
        sut.insertIntoCol(0, state: .player2)
        sut.insertIntoCol(1, state: .player1)
        sut.insertIntoCol(2, state: .player2)
        sut.insertIntoCol(3, state: .player1)
        sut.insertIntoCol(4, state: .player2)
        sut.insertIntoCol(5, state: .player1)
        sut.insertIntoCol(6, state: .player1)
        
        sut.insertIntoCol(0, state: .player2)
        sut.insertIntoCol(1, state: .player1)
        sut.insertIntoCol(2, state: .player2)
        sut.insertIntoCol(3, state: .player1)
        sut.insertIntoCol(4, state: .player2)
        sut.insertIntoCol(5, state: .player1)
        sut.insertIntoCol(6, state: .player1)
        
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(1, state: .player2)
        sut.insertIntoCol(2, state: .player1)
        sut.insertIntoCol(3, state: .player2)
        sut.insertIntoCol(4, state: .player1)
        sut.insertIntoCol(5, state: .player2)
        sut.insertIntoCol(6, state: .player1)
        
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(1, state: .player2)
        sut.insertIntoCol(2, state: .player1)
        sut.insertIntoCol(3, state: .player2)
        sut.insertIntoCol(4, state: .player1)
        sut.insertIntoCol(5, state: .player2)
        sut.insertIntoCol(6, state: .player2)
        
        sut.insertIntoCol(0, state: .player2)
        sut.insertIntoCol(1, state: .player1)
        sut.insertIntoCol(2, state: .player2)
        sut.insertIntoCol(3, state: .player1)
        sut.insertIntoCol(4, state: .player2)
        sut.insertIntoCol(5, state: .player1)
        sut.insertIntoCol(6, state: .player2)
        
        sut.insertIntoCol(0, state: .player1)
        sut.insertIntoCol(1, state: .player2)
        sut.insertIntoCol(2, state: .player1)
        sut.insertIntoCol(3, state: .player2)
        sut.insertIntoCol(4, state: .player1)
        sut.insertIntoCol(5, state: .player2)
        XCTAssertEqual(sut.gameState, GameState.inProgress, "gameState should equal 'inProgress' after all slots but 1 have been filled")
        
        sut.insertIntoCol(6, state: .player1)
        
        XCTAssertEqual(sut.gameState, GameState.draw, "gameState should equal 'draw' after all slots filled")
        
        
    }
}
