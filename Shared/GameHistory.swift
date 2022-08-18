//
//  GameHistory.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 18/08/2022.
//

import Foundation

class GameHistory: ObservableObject, Codable{
    @Published var history : [Stage] = []
    
    enum CodingKeys: CodingKey {
        case history
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(history, forKey: .history)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        history = try container.decode([Stage].self, forKey: .history)
    }
    
    func save(){
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let encodedData = try encoder.encode(self)
            UserDefaults.standard.set(encodedData, forKey: "GameHistory")
            print("wrote GameHistory to UserDefaults sucessfully.")
            //debug
    //        print(String(data: encodedData, encoding: .utf8))
        } catch {
            fatalError("Couldn't parse \(self):\n\(error)")
        }
    }
    
    func load(){
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: "GameHistory") as? Data,
       let gameHistory : GameHistory = try? decoder.decode(GameHistory.self, from: data){
            print("loaded history from UserDefaults sucessfully.")
            loadHistory(gameHistory)
        }
    }
    
    init() {
        loadHistory()
    }
    
    func loadHistory(_ gameHistory: GameHistory? = nil){
        if let gameHistory = gameHistory ?? loadFromUserDefaults() ?? nil{
            self.history = gameHistory.history
        }
        else {
            self.history = []
        }
    }
    
    func loadFromUserDefaults() -> GameHistory?{
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: "GameHistory") as? Data,
        let gameHistory : GameHistory = try? decoder.decode(GameHistory.self, from: data){
            print("loaded GameHistory from UserDefaults sucessfully.")
            return gameHistory
        }
        return nil
    }

}
