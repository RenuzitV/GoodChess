//
//  stage.boardView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct PossibleMoveCircle: View{
    var sizeq: Double
    
    let scale = 0.3
    
    var body: some View{
        Circle()
            .fill(.black)
            .opacity(0.3)
            .frame(maxWidth: sizeq*scale, maxHeight: sizeq*scale)
            .aspectRatio(1, contentMode: .fit)
        
    }
}

struct CleanBoardView: View{
    @ObservedObject var stage: Stage
    @State var processing = false
    @Binding var moved: Bool
    
    var botMoveMinimumDelay: Double
    
    var body: some View{
        VStack(spacing: 0){
            ForEach(0..<stage.board.row, id: \.self) { row in
                HStack(spacing: 0){
                    ForEach(0..<stage.board.col, id: \.self) { col in
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
                            
                            .if(stage.chosenPiecePosition == Position(row, col)){
                                $0.overlay(Color.yellow.opacity(0.3))
                            }
                        }
                        .allowsHitTesting(!processing)
                        .onTapGesture{
                            stage.resolveClick(at: Position(row, col))
                            if (stage.board.turn == .black && stage.versusBot){
                                //turn on processing to prevent player from interacting with the board
                                processing = true
                                var botMove: Move?
                                DispatchQueue.background(delay: botMoveMinimumDelay, background: {
                                    botMove = stage.getBotMove()
                                }, completion: {
                                    if let move = botMove {
                                        stage.makeBotMove(move: move)
                                    }
                                    stage.gameState = stage.checkGameState()
                                    stage.save()
                                    stage.resetMoves()
                                    moved.toggle()
                                    processing = false
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}

struct PiecesView: View{
    @Namespace var boardAnimation
    @ObservedObject var stage: Stage
    @ObservedObject var gameSetting: GameSetting
    
    var pieceMoveAnimationTime: Double
    
    var body: some View{
        VStack(spacing: 0){
            ForEach(0..<stage.board.row, id: \.self) { row in
                HStack(spacing: 0){
                    ForEach(0..<stage.board.col, id: \.self) { col in
                        ZStack{
                            //put piece
                            if let piece = stage.board[row, col]{
                                PieceView(piece: piece)
                                    .matchedGeometryEffect(id: piece.id, in: boardAnimation)
                                    .if(stage.versusBot == false && gameSetting.passToPlay == false && stage.board.turn == .black){
                                        $0.rotationEffect(.degrees(180))
                                    }
                            }
                        }
                        .id(UUID())
                        .animation(.linear(duration: pieceMoveAnimationTime), value: stage.board[row, col])
                        .frame(maxWidth: stage.board.sizeq, maxHeight: stage.board.sizeq)
                    }
                }
            }
        }
    }
}

struct PossibleMovesView: View{
    @ObservedObject var stage: Stage
    
    var body: some View{
        VStack(spacing: 0){
            ForEach(0..<stage.board.row, id: \.self) { row in
                HStack(spacing: 0){
                    ForEach(0..<stage.board.col, id: \.self) { col in
                        ZStack{
                            //put possible moves of a piece
                            if (stage.possibleMoves.contains(where: {$0.equals(x: row, y: col)})){
                                PossibleMoveCircle(sizeq: stage.board.sizeq)
                            }
                        }
                        .frame(maxWidth: stage.board.sizeq, maxHeight: stage.board.sizeq)
                    }
                }
            }
        }
    }
}


struct BoardView: View {
    @ObservedObject var stage: Stage
    @ObservedObject var gameSetting: GameSetting
        
    @Binding var moved: Bool
    
    //THIS VALUE HAS TO BE LESS THAN botMoveMinimumDelay
    let pieceMoveAnimationTime = 0.2
    //THIS VALUE HAS TO BE MORE THAN pieceMoveAnimationTime
    let botMoveMinimumDelay = 0.35
    
    var body: some View {
        //disable hit testing so we can pass the tap gesture to background
        ZStack{
            CleanBoardView(stage: stage, moved: $moved, botMoveMinimumDelay: botMoveMinimumDelay)
            PiecesView(stage: stage, gameSetting: gameSetting, pieceMoveAnimationTime: pieceMoveAnimationTime)
                .allowsHitTesting(false)
            PossibleMovesView(stage: stage)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: stage.board.size)
        .aspectRatio(1, contentMode: .fit)
    }
}

//im actually so dumb just use .disabled lmao
//subject to refactor if i actually get work done
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
                                PossibleMoveCircle(sizeq: board.sizeq)
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
    @State static var bool: Bool = false
    
    static var previews: some View {
        BoardView(stage: stage, gameSetting: gameSetting, moved: $bool)
        PossibleMoveCircle(sizeq: screenWidth)
            .background(
                Rectangle()
                    .fill(.brown)
                    .frame(width: screenWidth, height: screenWidth)
            )
    }
}
