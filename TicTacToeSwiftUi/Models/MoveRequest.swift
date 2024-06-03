//
//  MoveRequest.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 03/06/24.
//

import Foundation

struct MoveRequest: Codable {
    let type: String
    let move: Position
}
