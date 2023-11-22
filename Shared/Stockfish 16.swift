//
//  Stockfish 16.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 22/11/2023.
//

import Foundation

func fetchBestMoveFromStockfishAPI(fen: String, completion: @escaping (Move?) -> Void) {
    let headers = [
        "content-type": "application/x-www-form-urlencoded",
        "X-RapidAPI-Key": "50503f83ccmsh3fe129cba8717a7p101506jsnbe591c4bf6d5",
        "X-RapidAPI-Host": "chess-stockfish-16-api.p.rapidapi.com"
    ]

    let postData = NSMutableData(data: "fen=\(fen)".data(using: String.Encoding.utf8)!)

    let request = NSMutableURLRequest(url: NSURL(string: "https://chess-stockfish-16-api.p.rapidapi.com/chess/api")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData as Data

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
        guard let data = data, error == nil else {
            print("Error fetching data: \(String(describing: error))")
            completion(nil)
            return
        }

        if let moveString = parseStockfishResponse(data: data),
            let move = convertStringToMove(moveString: moveString) {
            print("Best move from Stockfish: \(moveString)")
            completion(move)
        } else {
            completion(nil)
        }
    }

    dataTask.resume()
}

// Function to parse the best move from Stockfish API response
func parseStockfishResponse(data: Data) -> String? {
    // Parse the response to extract the best move.
    // The exact parsing logic depends on the response format from the Stockfish API.
    // Assuming the response contains a field 'bestMove' which is a string representation of the move

    do {
        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let bestMoveString = jsonObject["bestmove"] as? String {
            return bestMoveString
        }
    } catch {
        print("Error parsing JSON: \(error)")
    }

    return nil
}
