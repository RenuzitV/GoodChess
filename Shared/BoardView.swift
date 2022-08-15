//
//  BoardView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct BoardView: View {
    var col = 8
    var row = 8
    var flipped = 0
    var size = min(screenWidth, maxBoardSize)
    var sizeq : Double {
        Double(size)/Double(col)
    }
    
    var body: some View {
        VStack(spacing: 0){
            ForEach((1...row), id: \.self) {row in
                HStack(spacing: 0){
                    ForEach((1...col), id: \.self) { col in
                        if ((row-1)*9+col-1)%2==flipped {
                            PieceView(size: sizeq, color: .accentColor)
                        }
                        else{
                            SquareView(size: sizeq, color: Color(red: 0.892, green: 0.837, blue: 0.791))
                        }
                    }
                }
            }
        }
        .frame(maxWidth: size)
        .aspectRatio(contentMode: .fit)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            
    }
}
