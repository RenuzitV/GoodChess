//
//  GameSetting.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 17/08/2022.
//

import Foundation
import SwiftUI

class GameSetting: ObservableObject{
    var passToPlay: Bool = true{
        didSet{
            objectWillChange.send()
            UserDefaults.standard.set(passToPlay, forKey: "passToPlay")
        }
    }
    var player1Name: String = "Player1"{
        didSet{
            objectWillChange.send()
            UserDefaults.standard.set(player1Name, forKey: "player1Name")
        }
    }
    var player2Name: String = "Player2"{
        didSet{
            objectWillChange.send()
            UserDefaults.standard.set(player2Name, forKey: "player2Name")
        }
    }
    var botDifficulty: BotDifficulty = .easy{
        didSet{
            objectWillChange.send()
            UserDefaults.standard.set(toBotDiffString(botDifficulty), forKey: "botDifficulty")
        }
    }
        
    init(){
        if let data = UserDefaults.standard.object(forKey: "passToPlay") as? Bool {
            self.passToPlay = data
        } else {
            passToPlay = true
        }
        if let data = UserDefaults.standard.object(forKey: "player1Name") as? String {
            self.player1Name = data
        } else {
            player1Name = "Duy Nguyen"
        }
        if let data = UserDefaults.standard.object(forKey: "player2Name") as? String {
            self.player2Name = data
        } else {
            player2Name = "Tom Huynh"
        }
        if let data = UserDefaults.standard.string(forKey: "botDifficulty"){
            self.botDifficulty = toBotDiffEnum(data)
        } else {
            botDifficulty = .easy
        }
    }
}
