//
//  StageView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct StageView: View {
    @EnvironmentObject var stage : Stage
    var body: some View {
        VStack{
            Text("game")
            BoardView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    }
}
