//
//  Player.swift
//  ConnectFour
//
//  Created by xxxxxxx on 28.09.20.
//

import UIKit

struct Player {
    let name: String
    let color: UIColor
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
}

extension Player: Equatable {
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name && lhs.color == rhs.color
    }
}
