//
//  StageView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct StageView: View {
    @ObservedObject var stage : Stage
    @ObservedObject var gameSetting: GameSetting
    @ObservedObject var gameHistory: GameHistory
    
    @State var gameEnded = false
    @State var p1Resign: Bool = false
    @State var p2Resign: Bool = false
    
    @Binding var currentSubviewIndex: Int
    @Binding var currentSubviewDepth: Int
    
    var resignSize = 0.3
    var duration = 0.7
    
    init(stage: Stage, gameSetting: GameSetting, gameHistory: GameHistory, currentSubviewIndex: Binding<Int>, currentSubviewDepth: Binding<Int>){
        self.stage = stage
        self.gameSetting = gameSetting
        self.gameHistory = gameHistory
        self._currentSubviewIndex = currentSubviewIndex
        self._currentSubviewDepth = currentSubviewDepth
    }
    
    var body: some View {
        VStack{
            Spacer()
            
            VStack{
                Text(stage.player2)
                    .font(.largeTitle)
                if (stage.versusBot == false){
                    ResignButton(size: resignSize, duration: duration, press: $p2Resign)
                }
            }
            .if(gameSetting.passToPlay){
                $0.rotationEffect(.degrees(0))
            }
            .if(!gameSetting.passToPlay){
                $0.rotationEffect(.degrees(180))
            }
            
            Spacer()
            
            BoardView(stage: stage, gameSetting: gameSetting)
            
            Spacer()
            
            VStack{
                Text(stage.player1)
                    .font(.largeTitle)
                ResignButton(size: resignSize, duration: duration, press: $p1Resign)
            }

            Spacer()
        }
        .onChange(of: p2Resign, perform: {_ in
            stage.gameState = .p1w
        })
        .onChange(of: p1Resign, perform: {_ in
            stage.gameState = .p2w
        })
        .onReceive(stage.$gameState, perform: {_ in
            if (stage.gameState != .playing && gameEnded == false){
                gameEnded = true
                if (stage.versusBot == true && stage.gameState == .p2w){
                    playSound(sound: "Defeat", numberOfLoops: -1)
                }
                else {
                    playSound(sound: "Victory", numberOfLoops: -1)
                }
            }
        })
        .alert("Game Ended!", isPresented: $gameEnded){
            Button(role: .cancel) {
                // Handle continue action.
                if (stage.versusBot == true && stage.gameState == .p2w){
                    stopSound(sound: "Defeat")
                } else{
                    stopSound(sound: "Victory")
                }
                
                //save to history
                gameHistory.history.append(Stage(stage: stage))
                gameHistory.save()
                
                //load new stage
                stage.loadNewStage()
                
                //go back to play menu
                self.showSubview(withIndex: 1, withDepth: 1)
            } label: {
                Text("Good Game!")
            }
        } message: {
            if (stage.gameState != .stalemate){
                Text("\(stage.gameState == .p1w ? stage.player1 : stage.player2) wins!")
            }
            else {
                Text("Game is in stalemate!")
            }
        }
        .onDisappear(perform: {
            stopSound(sound: "Defeat")
            stopSound(sound: "Victory")
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.accentColor)
    }
    
    private func showSubview(withIndex index: Int, withDepth depth: Int) {
        currentSubviewIndex = index
        currentSubviewDepth = depth
    }
}

struct ResignButton: View{
    var size: Double
    var duration: Double
    @GestureState var resignTap = false
    @Binding var press: Bool
    
    var body: some View{
        ZStack{
            Text("Resign")
                .customButton(0.3)
            
            RoundRect(0.3, Color.red.opacity(0.4))
                .clipShape(Rectangle().offset(x: resignTap ? 0 : -vw(size)))
        }
        .gesture(
            LongPressGesture(minimumDuration: duration, maximumDistance: 15).updating($resignTap){ currentState, gestureState, transaction in
                gestureState = currentState
            }
            .onEnded({ value in
                self.press.toggle()
                print("resigned")
            })
        )
        .animation(.linear(duration: duration), value: resignTap)
    }
    
}

struct StaticStageView: View {
    var stage : Stage
    var gameSetting: GameSetting
    
    init(_ stage: Stage, _ gameSetting: GameSetting){
        self.stage = stage
        self.gameSetting = gameSetting
    }
    
    var body: some View {
        VStack{
            Spacer()
            Text(stage.player2)
                .font(.largeTitle)
                .if(gameSetting.passToPlay){
                    $0.rotationEffect(.degrees(0))
                }
                .if(!gameSetting.passToPlay){
                    $0.rotationEffect(.degrees(180))
                }
            Spacer()
            StaticBoardView(board: stage.board)
            Spacer()
            Text(stage.player1)
                .font(.largeTitle)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.accentColor)
    }
}

struct Test: View{
    @State var press = false
    var body: some View{
        VStack{
            ResignButton(size: 0.3, duration: 0.7, press: $press)
            if (press){
                Text("resigned")
            }
        }
    }
}

struct StageView_Previews: PreviewProvider{
    static var previews: some View{
        Test()
    }
}



