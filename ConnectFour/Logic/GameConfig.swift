//
//  GameConfig.swift
//  ConnectFour
//
//  Created by xxxxx on 28.09.20.
//

import Foundation

struct GameConfig: Codable {
    let color1: String
    let color2: String
    let name1: String
    let name2: String

    static var defaultBackup: GameConfig {
        return GameConfig(color1: "#000FFF", color2: "#FFF000", name1: "P1", name2: "P2")
    }
}
