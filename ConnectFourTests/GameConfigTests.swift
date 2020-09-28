//
//  GameConfigTests.swift
//  ConnectFourTests
//
//  Created by xxxxxxx on 28.09.20.
//

import XCTest
@testable import ConnectFour

class GameConfigTests: XCTestCase {

    func test_GameConfigInits_whenDecoded() throws {
        
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
            XCTFail("Unable to create GameConfig test data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode([GameConfig].self, from: data)
            guard let config = decoded.first else {
                XCTFail("test GameConfig decoded but not in expected form")
                return
            }
            XCTAssertEqual(config.color1, "#FF0000", "color1 should equal '#FF0000'")
            XCTAssertEqual(config.color2, "#0000FF", "color1 should equal '#0000FF'")
            XCTAssertEqual(config.name1, "Sue", "color1 should equal 'Sue'")
            XCTAssertEqual(config.name2, "Henry", "color1 should equal 'Henry'")
            
        } catch {
            throw GameError.decodingError
        }
    }
}
