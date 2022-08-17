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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.accentColor)
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
//        StatefulPreviewWrapper(true){
//            StageView(navigationBarHidden: $0)
//                .environmentObject(Stage())
//        }
        StageView()
            .environmentObject(Stage())
            .environmentObject(GameSetting())
    }
}
