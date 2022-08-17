//
//  stage.boardView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct PossibleMoveCircle: View{
    var size: Double
    var body: some View{
        Circle()
            .fill(.black)
            .opacity(0.3)
            .frame(width: size, height: size)
        
    }
}

struct BoardView: View {
    @EnvironmentObject var stage : Stage
    
    var body: some View {
        VStack(spacing: 0){
            ForEach((0..<stage.board.row), id: \.self) {row in
                HStack(spacing: 0){
                    ForEach((0..<stage.board.col), id: \.self) { col in
                        //draws the chess board, one square at a time
                        //comprises of a square, a piece, and an optional circle indicating possible moves after choosing a piece
                        ZStack{
                            //flips color between squares
                            SquareView(size: stage.board.sizeq, color: .accentColor)
                            .if(((row*9+col)%2) == stage.board.flipped){
                                $0.overlay(Color.accentColor)
                            }
                            .if(((row*9+col)%2) != stage.board.flipped){
                                $0.overlay(Color(red: 0.892, green: 0.837, blue: 0.791))
                            }
                            .if(stage.lastMove != nil && ((stage.lastMove!.from == Position(row, col)) || (stage.lastMove!.to == Position(row, col)))){
                                $0.overlay(Color.green.opacity(0.3))
                            }
                            
                            //put piece
                            if let piece = stage.board[row, col] {
                                PieceView(piece: piece)
                            }
                            
                            //put possible moves of a piece
                            if (stage.possibleMoves.contains(where: {$0.equals(x: row, y: col)})){
                                PossibleMoveCircle(size: Double(stage.board.sizeq)*0.3)
                            }
                        }
                        //on tap tell stage to update moves or make a move
                        .onTapGesture {
                            stage.resolveClick(at: Position(row, col))
                        }
                    }
                }
            }
        }
        .frame(maxWidth: stage.board.size)
        .aspectRatio(contentMode: .fit)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(Stage())
        PossibleMoveCircle(size: screenWidth*0.2)
            .background(
                Rectangle()
                    .fill(.brown)
                    .frame(width: screenWidth, height: screenWidth)
            )
    }
}
