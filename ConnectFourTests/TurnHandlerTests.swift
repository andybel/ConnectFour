//
//  TurnHandlerTests.swift
//  ConnectFourTests
//
//  Created by xxxxxxx on 28.09.20.
//

import XCTest
@testable import ConnectFour

class TurnHandlerTests: XCTestCase {

    private var sut: TurnHandler!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        do {
            let config = try configForTest()
            sut = TurnHandler(with: config)
        } catch let err {
            throw err
        }
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_turnHandlerReturnsExpectedNames_afterTurnToggle() throws {
        
        XCTAssertEqual(sut.currentPlayer.name, "Sue")
        sut.toggleTurn()
        XCTAssertEqual(sut.currentPlayer.name, "Henry")
        sut.toggleTurn()
        XCTAssertEqual(sut.currentPlayer.name, "Sue")
    }
    
    func test_turnHandlerReturnsExpectedState_afterTurnToggle() throws {
        
        XCTAssertEqual(sut.slotStateForCurrentPlayer(), SlotState.player1)
        sut.toggleTurn()
        XCTAssertEqual(sut.slotStateForCurrentPlayer(), SlotState.player2)
        sut.toggleTurn()
        XCTAssertEqual(sut.slotStateForCurrentPlayer(), SlotState.player1)
    }
}

extension TurnHandlerTests {
    
    private func configForTest() throws -> GameConfig {
        
        guard let data = """
        [
            {
                "id":1234567890,
                "color1":"#FF0000",
                "color2":"#0000FF",
                "name1":"Sue",
                "name2":"Henry"
            }
        ]
""".data(using: .utf8) else {
            throw GameError.decodingError
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode([GameConfig].self, from: data)
        guard let config = decoded.first else {
            throw GameError.decodingError
        }
        return config
    }
}
