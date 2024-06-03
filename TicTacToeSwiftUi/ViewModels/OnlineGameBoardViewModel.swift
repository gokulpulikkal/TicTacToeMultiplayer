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
    
    @Published var wins: Int = 0
    @Published var loss: Int = 0
    @Published var alertVariable: Alerts?
    @Published var isDisabled = false
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    
    func processPlayerMove(at position: Int) {
        
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
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
        let workItem = DispatchWorkItem {
            let message = URLSessionWebSocketTask.Message.string(initGameMessage)
            self.webSocket?.send(message) { error in
                if let error = error {
                    print(error)
                }
            }
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: workItem)
    }
    
    func sendPlayerMove() {
        
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
    
    func handleIncomingMessage(_ strMessage: String) {
        // Parse JSON string
        guard let jsonData = strMessage.data(using: .utf8) else {
            print("Failed to convert string to data")
            return
        }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let jsonDict = jsonObject as? [String: Any] else {
                print("Failed to convert JSON object to dictionary")
                return
            }

            guard let type = jsonDict["type"] as? String else {
                print("Type is missing in received message")
                return
            }

            switch type {
            case "move":
                guard let payload = jsonDict["payload"] as? [String: Any] else {
                    print("Payload is missing or not of expected format")
                    return
                }
                guard let board = payload["board"] as? [[String]] else {
                    print("Board is missing or not of expected format")
                    return
                }
                // Now you have the board array, you can process it further
                print("Received move message:")
                print(board)

            case "game_over":
                guard let payload = jsonDict["payload"] as? [String: Any] else {
                    print("Payload is missing or not of expected format")
                    return
                }
                guard let winner = payload["winner"] as? String else {
                    print("Winner is missing or not of expected format")
                    return
                }
                // Now you have the winner, you can handle the game over event
                print("Game over. Winner: \(winner)")

            default:
                print("Unsupported message type: \(type)")
            }

        } catch {
            print("Error parsing JSON: \(error)")
        }
    }

    
    func resetWebSocket() {
        
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
