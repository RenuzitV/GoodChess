//
//  BoardView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct PossibleMoveCircle: View{
    var body: some View{
        Circle()
            .fill(.black)
            .opacity(0.2)
    }
}

struct BoardView: View {
    var board : Board = Board()
    @State var stage : Stage = Stage()
    
    var body: some View {
        VStack(spacing: 0){
            ForEach((0..<board.row), id: \.self) {row in
                HStack(spacing: 0){
                    ForEach((0..<board.col), id: \.self) { col in
                        //flips color between squares
                        if ((row)*9+col)%2==board.flipped {
                            ZStack{
                                SquareView(size: board.sizeq, color: .accentColor)
                                if let piece = board[row, col] {
                                    PieceView(piece: piece)
                                }
                                if (stage.possibleMoves.contains(where: Position(x: 1, y: 1))){
                                    
                                }
                            }
                            .onTapGesture {
                                stage.calcPossibleMoves(from: Position(x: row, y: col))
                            }
                        }
                        else {
                            ZStack{
                                SquareView(size: board.sizeq, color: Color(red: 0.892, green: 0.837, blue: 0.791))
                                if let piece = board[row, col] {
                                    PieceView(piece: piece)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: board.size)
        .aspectRatio(contentMode: .fit)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
