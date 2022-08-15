//
//  StageView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct StageView: View {
    @State var stage : Stage = Stage()
    var body: some View {
        VStack{
            Text("game")
            BoardView()
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(Stage())
            .environmentObject(Board())
    }
}
