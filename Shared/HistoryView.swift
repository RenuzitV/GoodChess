//
//  HistoryView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var history: GameHistory
    @State var showingBoard: Bool = false
    var body: some View {
        ScrollView{
            VStack{
                ForEach(history.history){stage in
                    HStack{
                        HistoryRow(stage: stage)
                            .onTapGesture {
                                showingBoard.toggle()
                            }
                    }
                    .sheet(isPresented: $showingBoard, content: {
                        StaticBoardView(board: Board(board: stage.board))
                    })
                }
                .onDelete(perform: delete)
            }
        }
        .padding()
        .foregroundColor(.accentColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func delete(at offsets: IndexSet) {
        history.history.remove(atOffsets: offsets)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(GameHistory())
    }
}

struct HistoryRow: View{
    var stage: Stage
    var body: some View{
        Text("\(stage.player1) \(calcScore()) vs \(calcScore(true)) \(stage.player2)")
            .customButton(0.8)
            .font(.title3)
    }
    
    func calcScore(_ opposite: Bool = false) -> String{
        return stage.gameState == .p1w ? (opposite ? "0" : "1") : stage.gameState == .p2w ? (opposite ? "1" : "0") : "0.5"
    }
}
