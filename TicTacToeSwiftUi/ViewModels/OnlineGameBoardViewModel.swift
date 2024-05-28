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
        
    }
    
    func initGame() {
        //Session
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        //Server API
        let url = URL(string:  "ws://localhost:8080")
        
        //Socket
        webSocket = session.webSocketTask(with: url!)
        
        //Connect and hanles handshake
        webSocket?.resume()
    }
    
    func sendPlayerMove() {
        
    }
    
    func resetWebSocket() {
        
    }
}

extension OnlineGameBoardViewModel: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connected to server")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Disconnect from Server \(reason)")
    }
}
