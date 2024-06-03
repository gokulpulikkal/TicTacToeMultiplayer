//
//  ServerResponse.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 03/06/24.
//

import Foundation

// Define structs for each payload type
struct InitGamePayload: Codable {
    let symbol: String
    let isYourTurn: Bool
}

struct MovePayload: Codable {
    let board: [[String]]?
    let isYourTurn: Bool
}

struct GameOverPayload: Codable {
    let winner: String?
    let board: [[String]]?
}

// Define an enum for the response type
enum ServerResponse: Codable {
    case initGame(InitGamePayload)
    case move(MovePayload)
    case gameOver(GameOverPayload)
    
    enum CodingKeys: String, CodingKey {
        case type
        case payload
    }
    
    enum ResponseType: String, Codable {
        case initGame = "init_game"
        case move
        case gameOver = "game_over"
    }
    
    // Implement custom decoding to handle the different payloads
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ResponseType.self, forKey: .type)
        
        switch type {
        case .initGame:
            let payload = try container.decode(InitGamePayload.self, forKey: .payload)
            self = .initGame(payload)
        case .move:
            let payload = try container.decode(MovePayload.self, forKey: .payload)
            self = .move(payload)
        case .gameOver:
            let payload = try container.decode(GameOverPayload.self, forKey: .payload)
            self = .gameOver(payload)
        }
    }
    
    // Implement custom encoding if necessary (not required for decoding)
    func encode(to encoder: Encoder) throws {
        // Implementation for encoding, if needed
    }
}
