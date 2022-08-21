//
//  StageView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct StageView: View {
    @EnvironmentObject var stage : Stage
    @EnvironmentObject var gameSetting: GameSetting
    @EnvironmentObject var gameHistory: GameHistory
    
    @State var gameEnded = false
    
    @Binding var currentSubviewIndex: Int
    @Binding var currentSubviewDepth: Int
    
    init(currentSubviewIndex: Binding<Int>, currentSubviewDepth: Binding<Int>){
        self._currentSubviewIndex = currentSubviewIndex
        self._currentSubviewDepth = currentSubviewDepth
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
            BoardView()
            Spacer()
            Text(stage.player1)
                .font(.largeTitle)
            Spacer()
        }
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
    @GestureState var resignTap = false
    @Binding var press: Bool
    
    var body: some View{
        ZStack{
            Text("Resign")
                .font(.title)
        }
        .gesture(
            LongPressGesture(minimumDuration: 2, maximumDistance: 15).updating($resignTap){ currentState, gestureState, transaction in
                gestureState = currentState
                print("asd")
            }
                .onEnded({ value in
                    self.press.toggle()
                })
        )
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
            StaticBoardView(stage: stage)
            Spacer()
            Text(stage.player1)
                .font(.largeTitle)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.accentColor)
    }
}

struct StageView_Previews: PreviewProvider{
    @State static var press = false
    static var previews: some View{
        VStack{
            ResignButton(size: 0.3, press: $press)
                .customButton(0.3)
            if (press){
                Text("resigned")
            }
        }
    }
}



