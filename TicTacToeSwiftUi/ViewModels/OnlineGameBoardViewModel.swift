//
//  OnlineGameBoardViewModel.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 27/05/24.
//

import Foundation
import SwiftUI

class OnlineGameBoardViewModel: NSObject, ObservableObject {
    
    private var webSocket : URLSessionWebSocketTask?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var isGameStarted: Bool = false
    @Published var wins: Int = 0
    @Published var loss: Int = 0
    @Published var alertVariable: Alerts?
    @Published var isDisabled = false
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    private var homeSymbol: String?
    
    func processPlayerMove(at position: Int) {
        if !isMoveAlreadyOccupied(moves: moves, for: position) {
            moves[position] = Move(player: .homePlayer, boardIndex: position, isOnlineGame: true, homePlayerImage: homeSymbol)
            sendPlayerMove(at: position)
        }
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        let resetGameMessage = """
        {
            "type": "reset_game"
        }
        """
        send(resetGameMessage)
    }
    
    func isMoveAlreadyOccupied(moves: [Move?], for index: Int) -> Bool {
        return index < moves.count && moves[index] != nil
    }
    
    func positionToRowCol(position: Int) -> (row: Int, col: Int)? {
        guard position >= 0 && position <= 8 else {
            return nil
        }
        
        let row = position / 3
        let col = position % 3
        return (row, col)
    }
    
    private func updateTheLocalBoard(_ board: [[String]]) {
        var newBoard = [Move?]()
        var index = 0
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                if board[i][j] != "" {
                    var player = Player.opponent
                    if homeSymbol == MarkingImage.XMARK.rawValue && board[i][j] == "X" || homeSymbol == MarkingImage.CIRCLE.rawValue && board[i][j] == "O" {
                        player = Player.homePlayer
                    }
                    
                    let move = Move(player: player, boardIndex: index, isOnlineGame: true, homePlayerImage: homeSymbol)
                    newBoard.append(move)
                    index += 1
                } else {
                    newBoard.append(nil)
                }
            }
        }
        moves = newBoard
    }
    
    
//    Network calls
    func connectToWebSocket() {
        print("starting the game")
        //Session
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        //Server API
        let url = URL(string:  "ws://localhost:8080")
        
        //Socket
        webSocket = session.webSocketTask(with: url!)
        
        //Connect and handles handshake
        webSocket?.resume()
    }
    
    func initGame() {
        let initGameMessage = """
        {
            "type": "init_game"
        }
        """
        send(initGameMessage)
    }
    
    func sendPlayerMove(at position: Int) {
        if let (row, col) = positionToRowCol(position: position) {
            let pos = Position(row: row, col: col)
            let moveRequest = MoveRequest(type: "move", move: pos)
            
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(moveRequest)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    send(jsonString)
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
        }
    }
    
    func resetWebSocket() {
        
    }
    
    func handleIncomingMessage(_ strMessage: String) {
        // Parse JSON string
        guard let jsonData = strMessage.data(using: .utf8) else {
            print("Failed to convert string to data")
            return
        }
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ServerResponse.self, from: jsonData)
            DispatchQueue.main.async {
                switch response {
                case .initGame(let payload):
                    print("Init Game: Symbol - \(payload.symbol), Is Your Turn - \(payload.isYourTurn)")
                    self.isDisabled = !payload.isYourTurn
                    if payload.symbol == "X" {
                        self.homeSymbol = MarkingImage.XMARK.rawValue
                    } else {
                        self.homeSymbol = MarkingImage.CIRCLE.rawValue
                    }
                    self.isGameStarted = true
                case .move(let payload):
                    if let board = payload.board {
                        print("Move: Board - \(board), Is Your Turn - \(payload.isYourTurn)")
                        self.updateTheLocalBoard(board)
                    }
                    self.isDisabled = !payload.isYourTurn
                case .gameOver(let payload):
                    if let board = payload.board {
                        print("Move: Board - \(board)")
                        self.updateTheLocalBoard(board)
                    }
                    if let winner = payload.winner {
                        print("Move: Winner - \(winner)")
                        if self.homeSymbol == MarkingImage.XMARK.rawValue && winner == "X" || self.homeSymbol == MarkingImage.CIRCLE.rawValue && winner == "O" {
                            self.wins += 1
                            self.alertVariable = AlertContexts.homeWin
                        } else {
                            self.loss += 1
                            self.alertVariable = AlertContexts.opponentWin
                        }
                    }
                }
            }
            
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    
    func send(_ message: String) {
        let workItem = DispatchWorkItem {
            let messageTask = URLSessionWebSocketTask.Message.string(message)
            self.webSocket?.send(messageTask) { error in
                if let error = error {
                    print(error)
                }
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: workItem)
    }
    
    //MARK: Receive
    func receive() {
        let workItem = DispatchWorkItem{ [weak self] in
            self?.webSocket?.receive(completionHandler: { result in
                switch result {
                case .success(let message):
                    
                    switch message {
                    
                    case .data(let data):
                        print("Data received \(data)")
                        
                    case .string(let strMessage):
                        self?.handleIncomingMessage(strMessage)
                        
                    default:
                        break
                    }
                
                case .failure(let error):
                    print("Error Receiving \(error)")
                }
                // Creates the Recurrsion
                self?.receive()
            })
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: workItem)
    }
}

extension OnlineGameBoardViewModel: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connected to server")
        initGame()
        receive()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Disconnect from Server \(reason)")
    }
}

