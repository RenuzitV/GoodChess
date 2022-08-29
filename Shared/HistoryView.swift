//
//  HistoryView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var history: GameHistory
    @ObservedObject var gameSetting: GameSetting
    @State var stageToShow : Stage? = nil
    
    var body: some View {
        ScrollView{
            ForEach(history.history.reversed()){stage in
                HStack{
                    HistoryRow(stage: stage)
                        .onTapGesture {
                            stageToShow = stage
                        }
                }
                .padding(.bottom, 5)
            }
        }
        .sheet(item: $stageToShow, content: { stageToShow in
            SheetView(stageToShow, gameSetting, history: history)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
        })
        .transition(.slide)
        .animation(.default, value: history.history)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .foregroundColor(.accentColor)
        .onAppear(){
            pauseSound(sound: "bg1")
            playSound(sound: "bg2", numberOfLoops: -1, atTime: 3)
        }
        .onDisappear(){
            pauseSound(sound: "bg2")
        }
    }
    
    func delete(at offsets: IndexSet) {
        history.history.remove(atOffsets: offsets)
    }
}

struct SheetView: View{
    var stage: Stage
    var gameSetting: GameSetting
    
    @ObservedObject var history: GameHistory
    
    @Environment(\.presentationMode) var presentationMode
    
    init (_ stage: Stage, _ gameSetting: GameSetting, history: GameHistory){
        self.stage = stage
        self.gameSetting = gameSetting
        self.history = history
    }
    
    var body: some View{
        VStack{
            HStack{
                Text("Close")
                    .font(.title3)
                    .padding(10)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Text("Delete")
                    .font(.title3)
                    .padding(10)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .onTapGesture {
                        for idx in history.history.indices{
                            if (history[idx] == stage){
                                history.history.remove(at: idx)
                                history.save()
                                break
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                
            }
            StaticStageView(stage, gameSetting)
        }
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: GameHistory(), gameSetting: GameSetting())
    }
}

struct HistoryRow: View{
    var stage: Stage
    var body: some View{
        Text("\(stage.player1) \(calcScore()) vs \(calcScore(true)) \(stage.player2)")
            .customButton(0.9, font: .title3)
    }
    
    func calcScore(_ opposite: Bool = false) -> String{
        return stage.gameState == .p1w ? (opposite ? "0" : "1") : stage.gameState == .p2w ? (opposite ? "1" : "0") : "0.5"
    }
}
