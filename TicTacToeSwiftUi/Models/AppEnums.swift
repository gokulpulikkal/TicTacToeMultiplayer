//
//  AppEnums.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 03/06/24.
//

import Foundation

enum MessageTypes: String {
    case INIT_GAME = "init_game"
    case MOVE = "move"
    case GAME_OVER = "game_over"
    case RESET_GAME = "reset_game"
}

enum Player {
    case human
    case computer
    case opponent
    case homePlayer
}

enum MarkingImage: String {
    case CIRCLE = "circle"
    case XMARK = "xmark"
}
