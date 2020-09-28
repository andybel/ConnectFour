//
//  GameManagerTests.swift
//  ConnectFourTests
//
//  Created by Andy Bell on 28.09.20.
//

import XCTest
@testable import ConnectFour

class GameManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_GameManageReportsExpectedFreeSlots_whenInitialised() throws {
        
        let sut = GameManager(columnCount: 7, rowCount: 6)
        
        XCTAssertNotNil(sut.freeSlotIdxInCol(0), "Column 0 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(1), "Column 1 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(2), "Column 2 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(3), "Column 3 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(4), "Column 4 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(5), "Column 5 should have free slots after init")
        XCTAssertNotNil(sut.freeSlotIdxInCol(6), "Column 6 should have free slots after init")
    }
}
