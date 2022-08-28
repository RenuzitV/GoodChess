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
            .frame(maxWidth: size, maxHeight: size)
            .aspectRatio(1, contentMode: .fit)
        
    }
}

struct BoardView: View {
    @ObservedObject var stage: Stage
    @ObservedObject var gameSetting: GameSetting
    
    @State var processing: Bool = false
    
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
                            //show last move
                            .if(stage.lastMove != nil && ((stage.lastMove!.from == Position(row, col)) || (stage.lastMove!.to == Position(row, col)))){
                                $0.overlay(Color.green.opacity(0.3))
                            }
                            
                            //put piece
                            if let piece = stage.board[row, col] {
                                PieceView(piece: piece)
                                    .if(stage.versusBot == false && gameSetting.passToPlay == false && stage.board.turn == .black){
                                        $0.rotationEffect(.degrees(180))
                                    }
                            }
                            
                            //put possible moves of a piece
                            if (stage.showMoves.contains(where: {$0.equals(x: row, y: col)})){
                                PossibleMoveCircle(size: Double(stage.board.sizeq)*0.3)
                            }
                        }
                        //on tap tell stage to update moves or make a move
                        .onTapGesture{
                            if (!processing) {
                                stage.resolveClick(at: Position(row, col))
                            }
                        }
                        .onReceive(stage.$moved, perform: {_ in
                            if (!processing && stage.board.turn == .black && stage.versusBot){
                                processing = true
                                Task{
                                    await stage.lastMove = stage.makeBotMove()
                                    stage.gameState = stage.checkGameState()
                                    processing = false
                                }
                            }
                        })
                    }
                }
            }
        }
        .frame(maxWidth: stage.board.size)
        .aspectRatio(1, contentMode: .fit)
    }
}

struct StaticBoardView: View{
    var board: Board
    var possibleMoves: [Position] = []
    
    var body: some View {
        VStack(spacing: 0){
            ForEach((0..<board.row), id: \.self) {row in
                HStack(spacing: 0){
                    ForEach((0..<board.col), id: \.self) { col in
                        //draws the chess board, one square at a time
                        //comprises of a square, a piece, and an optional circle indicating possible moves after choosing a piece
                        ZStack{
                            //flips color between squares
                            SquareView(size: board.sizeq, color: .accentColor)
                                .if(((row*9+col)%2) == board.flipped){
                                    $0.overlay(Color.accentColor)
                                }
                                .if(((row*9+col)%2) != board.flipped){
                                    $0.overlay(Color(red: 0.892, green: 0.837, blue: 0.791))
                                }
                            
                            //put piece
                            if let piece = board[row, col] {
                                PieceView(piece: piece)
                            }
                            
                            //put possible moves of a piece
                            if (possibleMoves.contains(where: {$0.equals(x: row, y: col)})){
                                PossibleMoveCircle(size: Double(board.sizeq)*0.3)
                            }

                        }
                    }
                }
            }
        }
        .frame(maxWidth: board.size)
        .aspectRatio(1, contentMode: .fit)
        .centerAligned()
    }
}

struct BoardView_Previews: PreviewProvider {
    static var stage: Stage = Stage()
    static var gameSetting: GameSetting = GameSetting()
    
    static var previews: some View {
        BoardView(stage: stage, gameSetting: gameSetting)
        PossibleMoveCircle(size: screenWidth*0.2)
            .background(
                Rectangle()
                    .fill(.brown)
                    .frame(width: screenWidth, height: screenWidth)
            )
    }
}
