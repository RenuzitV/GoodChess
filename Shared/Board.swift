//
//  Board.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation

class Board : ObservableObject{
    var col = 8
    var row = 8
    
    var flipped = 1
    
    var size = min(screenWidth, maxBoardSize)
    
    var sizeq : Double {
        Double(size)/Double(col)
    }
    
    @Published var board : [[Piece?]] = [[Piece?]](repeating: [Piece?](repeating: nil, count: 8), count: 8)
    @Published var turn : PieceColor = .white
    
    subscript (i: Int, j : Int) -> Piece? {
        get{
            return self.board[i][j]
        }
        set{
            self.board[i][j] = newValue
        }
    }
    
    subscript (at : Position) -> Piece?{
        get{
            return self.board[at.x][at.y]
        }
        set{
            self.board[at.x][at.y] = newValue
        }
    }
    
    init(board: Board){
        self.board = board.board
        self.turn = board.turn
    }
    
    init(asWhite: Bool = true){
        //pawns
        for i in 0...7{
            board[1][i] = Pawn(pieceName: "bp")
            board[6][i] = Pawn(pieceName: "wp")
        }
        
        //black side
        board[0][0] = Rook(pieceName: "br")
        board[0][7] = Rook(pieceName: "br")
        board[0][1] = Knight(pieceName: "bn")
        board[0][6] = Knight(pieceName: "bn")
        board[0][2] = Bishop(pieceName: "bb")
        board[0][5] = Bishop(pieceName: "bb")
        board[0][3] = Queen(pieceName: "bq")
        board[0][4] = King(pieceName: "bk")
        
        //white side
        board[7][0] = Rook(pieceName: "wr")
        board[7][7] = Rook(pieceName: "wr")
        board[7][1] = Knight(pieceName: "wn")
        board[7][6] = Knight(pieceName: "wn")
        board[7][2] = Bishop(pieceName: "wb")
        board[7][5] = Bishop(pieceName: "wb")
        board[7][3] = Queen(pieceName: "wq")
        board[7][4] = King(pieceName: "wk")
        
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
    
    //checks if this board is valid i.e. does not leave the king open or is against the law
    func isValid() -> Bool{
        for i in board.indices{
            for j in board[i].indices{
                if let piece = board[i][j]{
                    let pos = Position(x: i, y: j)
                    //we dont need to check for opposite colors since the only way a piece's possible moves is not nil is that the occupying piece is of opposite color already
                    if piece.possibleMoves(at: pos, board: self).contains(where: {
                        return self[$0] != nil && self[$0]!.name == .king && self[$0]?.color == turn
                    }){
                        return false
                    }
                }
            }
        }
        return true
    }

}
