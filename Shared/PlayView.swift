//
//  PlayView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//https://stackoverflow.com/questions/61424225/macos-swiftui-navigation-for-a-single-view
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views

import Foundation
import SwiftUI

struct PlayView: View {
    @ObservedObject var stage: Stage
    @ObservedObject var gameSetting: GameSetting
    
    @State var isOngoingGame: Bool
    @State var versusBot: Bool = false
    
    @Binding var currentSubviewIndex: Int
    @Binding var currentSubviewDepth: Int
    
    init(stage: Stage, gameSetting: GameSetting, currentSubviewIndex: Binding<Int>, currentSubviewDepth: Binding<Int>){
        self.stage = stage
        self.gameSetting = gameSetting
        self._currentSubviewIndex = currentSubviewIndex
        self._currentSubviewDepth = currentSubviewDepth
        self.isOngoingGame = false
    }
    
    var body: some View {
        VStack{
            Spacer()
            
            //singleplayer
            Button(action: {
                stage.startGame(versusBot: true, player1: gameSetting.player1Name, botDifficulty: gameSetting.botDifficulty)
                self.showSubview(withIndex: 4, withDepth: 2)
            }) {
                Label("Play with Bot", systemImage: "person")
            }
            .customButton(0.7)
            
            Spacer()
            
            //multiplayer
            Button(action: {
                stage.startGame(versusBot: false, player1: gameSetting.player1Name, player2: gameSetting.player2Name)
                self.showSubview(withIndex: 4, withDepth: 2)
            }) {
                Label("Play with Friend", systemImage: "person.2")
            }
            .customButton(0.7)
            
            Spacer()
            
            //continue
            if (stage.gameState == .playing){
                Button(action: {
                    isOngoingGame = true
                }) {
                    Label("Continue Playing", systemImage: "play.fill")
                }
                .customButton(0.7)
            }
            
            Spacer()
        }
        .foregroundColor(.accentColor)
        .font(.title)
        .alert("Ongoing Game", isPresented: $isOngoingGame){
            Button(role: .destructive) {
                // Handle delete action i.e. start new game
                stage.loadNewStage()
//                stage.gameState = .playing
//                stage.versusBot = versusBot
//                stage.startGame(versusBot: versusBot, player1: gameSetting.player1Name, player2: versusBot ? "Bot (Easy)" : gameSetting.player2Name)
//                stage.save()
//                self.showSubview(withIndex: 4, withDepth: 2)
            } label: {
                Text("No")
            }
            Button(role: .cancel) {
                // Handle continue action.
                self.showSubview(withIndex: 4, withDepth: 2)
            } label: {
                Text("Yes")
            }
        } message: {
            Text("You have an ongoing game between:\n \(stage.player1) and \(stage.player2) \nDo you want to continue playing?")
        }
        .onAppear(){
            if (!isPlaying(sound: "bg1")){
                playSound(sound: "bg1", numberOfLoops: -1)
            }
        }
        .animation(.easeOut)
    }
    
    private func showSubview(withIndex index: Int, withDepth depth: Int) {
        currentSubviewIndex = index
        currentSubviewDepth = depth
    }
}
