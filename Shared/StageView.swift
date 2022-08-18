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
            if (stage.gameState != .playing){
                gameEnded = true
            }
        })
        .alert("Game Ended!", isPresented: $gameEnded){
            Button(role: .cancel) {
                // Handle continue action.
                stage.loadNewStage()
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.accentColor)
    }
    
    private func showSubview(withIndex index: Int, withDepth depth: Int) {
        currentSubviewIndex = index
        currentSubviewDepth = depth
    }
}
