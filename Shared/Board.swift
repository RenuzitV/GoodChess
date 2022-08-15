//
//  Board.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation

struct Board{
    var col = 8
    var row = 8
    
    var flipped = 1
    
    var size = min(screenWidth, maxBoardSize)
    
    var sizeq : Double {
        Double(size)/Double(col)
    }
    
    var board : [[Piece?]] = [[Piece?]](repeating: [Piece?](repeating: nil, count: 8), count: 8)
    
    subscript (i: Int, j : Int) -> Piece? {
        return self.board[i][j]
    }
    
    init(asWhite: Bool = true){
        //pawns
        for i in 0...7{
            board[1][i] = Piece(pieceName: "bp")
            board[6][i] = Piece(pieceName: "wp")
        }
        
        //black side
        board[0][0] = Piece(pieceName: "br")
        board[0][7] = Piece(pieceName: "br")
        board[0][1] = Piece(pieceName: "bn")
        board[0][6] = Piece(pieceName: "bn")
        board[0][2] = Piece(pieceName: "bb")
        board[0][5] = Piece(pieceName: "bb")
        board[0][3] = Piece(pieceName: "bq")
        board[0][4] = Piece(pieceName: "bk")
        
        //white side
        board[7][0] = Piece(pieceName: "wr")
        board[7][7] = Piece(pieceName: "wr")
        board[7][1] = Piece(pieceName: "wn")
        board[7][6] = Piece(pieceName: "wn")
        board[7][2] = Piece(pieceName: "wb")
        board[7][5] = Piece(pieceName: "wb")
        board[7][3] = Piece(pieceName: "wq")
        board[7][4] = Piece(pieceName: "wk")
        
        if (!asWhite){
            for i in 0...7{
                for j in 0...7{
                    //trick to both assign and check for nil values
                    if let piece = board[i][j]{
                        piece.color = piece.color == .white ? .black : .white
                    }
                }
            }
        }
    }
    
}
