//
//  GameError.swift
//  ConnectFour
//
//  Created by Andy Bell on 28.09.20.
//

import Foundation

enum GameError: Error {
    case urlError
    case decodingError
    case system(Error)
    case general(String)
}
