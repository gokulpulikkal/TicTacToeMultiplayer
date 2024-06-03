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
    var isOnlineGame: Bool = false
    var homePlayerImage: String?
    
    var markingImage: String {
        if !isOnlineGame {
            return player == .human ? MarkingImage.CIRCLE.rawValue: MarkingImage.XMARK.rawValue
        } else {
            if player == .homePlayer {
                return homePlayerImage ?? ""
            } else {
                return homePlayerImage == MarkingImage.CIRCLE.rawValue ? MarkingImage.XMARK.rawValue: MarkingImage.CIRCLE.rawValue
            }
        }
        
    }
}
