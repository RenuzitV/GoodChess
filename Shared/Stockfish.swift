//
//  Stockfish.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 20/11/2023.
// Made with help of OpenAI's Chat GPT

import Foundation

func boardToFEN(board: Board) -> String {
    var fen = ""

    // Piece placement
    for row in 0..<8 {
        var emptyCount = 0
        for col in 0..<8 {
            if let piece = board[row, col] {
                if emptyCount > 0 {
                    fen += "\(emptyCount)"
                    emptyCount = 0
                }
                fen += pieceToFEN(piece: piece)
            } else {
                emptyCount += 1
            }
        }
        if emptyCount > 0 {
            fen += "\(emptyCount)"
        }
        if row < 7 {
            fen += "/"
        }
    }

    // Active color
    fen += " " + (board.turn == .white ? "w" : "b")

    // Castling availability
    fen += " " + castlingAvailability(board: board)

    // Add placeholders for en passant, halfmove clock, and fullmove number
    fen += " - 0 1"

    return fen
}

func castlingAvailability(board: Board) -> String {
    var castling = ""

    // Assuming the king is at (7,4) for white and (0,4) for black
    // Assuming rooks are at (7,0), (7,7), (0,0), and (0,7)
    if let king = board[7, 4], king.name == .king, king.firstMove {
        if let rook = board[7, 7], rook.name == .rook, rook.firstMove {
            castling += "K"
        }
        if let rook = board[7, 0], rook.name == .rook, rook.firstMove {
            castling += "Q"
        }
    }
    if let king = board[0, 4], king.name == .king, king.firstMove {
        if let rook = board[0, 7], rook.name == .rook, rook.firstMove {
            castling += "k"
        }
        if let rook = board[0, 0], rook.name == .rook, rook.firstMove {
            castling += "q"
        }
    }

    return castling.isEmpty ? "-" : castling
}

func pieceToFEN(piece: Piece) -> String {
    let fenMap: [PieceType: String] = [
        .king: "k", .queen: "q", .rook: "r", .bishop: "b", .knight: "n", .pawn: "p"
    ]

    if let fenChar = fenMap[piece.name] {
        return piece.color == .white ? fenChar.uppercased() : fenChar
    }

    return "" // Or some error handling
}

// Function to fetch the best move from Lichess API
func fetchBestMoveFromLichess(fen: String, completion: @escaping (Move?) -> Void) {
    let urlString = "https://lichess.org/api/cloud-eval?fen=\(fen.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
    print("getting move from lichess api:\n\(urlString)")
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        if let moveString = parseBestMoveFromResponse(data: data) {
            let move = convertStringToMove(moveString: moveString)
            print("got success response from lichess: \(moveString).")
            completion(move)
        } else {
            completion(nil)
        }
    }

    task.resume()
}

// Function to parse the best move from Lichess API response
func parseBestMoveFromResponse(data: Data) -> String? {
    do {
        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let pvs = jsonObject["pvs"] as? [[String: Any]],
           let firstPv = pvs.first,
           let moves = firstPv["moves"] as? String {
            return moves.split(separator: " ").first.map(String.init)
        }
    } catch {
        print("Error parsing JSON: \(error)")
    }

    return nil
}

// Function to convert a move string (e.g., "e2e4") to a Move object
func convertStringToMove(moveString: String) -> Move? {
    guard moveString.count == 4,
          let fromCol = moveString.first,
          let fromRow = moveString.dropFirst().first,
          let toCol = moveString.dropFirst(2).first,
          let toRow = moveString.last else {
        return nil
    }

    let from = Position(7 - Int(fromRow.asciiValue! - Character("1").asciiValue!), Int(fromCol.asciiValue! - Character("a").asciiValue!))
    let to = Position(7 - Int(toRow.asciiValue! - Character("1").asciiValue!), Int(toCol.asciiValue! - Character("a").asciiValue!))

    return Move(from: from, to: to)
}
