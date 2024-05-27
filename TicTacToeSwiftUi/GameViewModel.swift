//
//  GameViewModel.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul on 11/07/21.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isDisabled = false
    @Published var alertVariable: Alerts?
    
    @Published var humanScore: Int = 0
    @Published var computerScore: Int = 0
    
    func processPlayerMove(at position: Int) {
        if !isMoveAlreadyOccupied(moves: moves, for: position) {
            moves[position] = Move(player: .human, boardIndex: position)
            if checkWinCondition(for: moves, player: .human) {
                humanScore += 1
                alertVariable = AlertContexts.humanWin
                return
            }
            if checkDrawCase(for: moves) {
                alertVariable = AlertContexts.drawCase
                return
            }
            isDisabled = true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [self] in
                let computerMoveIndex = getComputerMove(for: moves)
                moves[computerMoveIndex] = Move(player: .computer, boardIndex: computerMoveIndex)
                if checkWinCondition(for: moves, player: .computer) {
                    computerScore += 1
                    alertVariable = AlertContexts.computerWin
                    return
                }
                if checkDrawCase(for: moves) {
                    alertVariable = AlertContexts.drawCase
                    return
                }
                isDisabled = false
            }
        }
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
    
    func isMoveAlreadyOccupied(moves: [Move?], for index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func getComputerMove(for moves: [Move?]) -> Int {
        var computerMoveIndex = Int.random(in: 0..<9)
        while isMoveAlreadyOccupied(moves: moves, for: computerMoveIndex) {
            computerMoveIndex = Int.random(in: 0..<9)
        }
        return computerMoveIndex
    }
    
    func checkWinCondition(for moves: [Move?], player: Player) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap{ $0 }.filter{ $0.player == player }
        let playerMoveIndex = Set(playerMoves.map{$0.boardIndex})
        for item in winPatterns where item.isSubset(of: playerMoveIndex) { return true }
        return false
    }
    
    func checkDrawCase(for moves: [Move?]) -> Bool {
        if moves.compactMap({$0}).count == 9 {
            return true
        }
        return false
    }
}
