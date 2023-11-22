//
//  Stockfish.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 20/11/2023.
// Made with help of OpenAI's Chat GPT

import Foundation

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
