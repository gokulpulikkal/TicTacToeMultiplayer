//
//  Move.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 27/05/24.
//

import Foundation

struct Move {
    var player: Player
    var boardIndex: Int
    
    var markingImage: String {
        return player == .human ? "circle": "xmark"
    }
}
