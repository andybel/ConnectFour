//
//  GameManagerTests.swift
//  ConnectFourTests
//
//  Created by Andy Bell on 28.09.20.
//

import XCTest
@testable import ConnectFour

class GameManagerTests: XCTestCase {

    private var sut: GameManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = GameManager(columnCount: 7, rowCount: 6)
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
        
        sut.insertIntoCol(0, state: .red)
        sut.insertIntoCol(0, state: .red)
        sut.insertIntoCol(0, state: .red)
        sut.insertIntoCol(0, state: .red)
        
        let nextFreeIdx = sut.freeSlotIdxInCol(0)
        XCTAssertNotNil(nextFreeIdx, "next free slot idx should not be nil after 3 insertions")
        XCTAssertEqual(nextFreeIdx, 1, "next free slot idx should be 1 after 4 insertions")
        
        sut.insertIntoCol(0, state: .red)
        sut.insertIntoCol(0, state: .red)
        let idxForFullColumn = sut.freeSlotIdxInCol(0)
        XCTAssertNil(idxForFullColumn, "slot idx should be nil after 6 insertions")
    }
}
