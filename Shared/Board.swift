//
//  Board.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation

class Board : ObservableObject, Codable, Hashable, Equatable{
    
    let row = 8
    let col = 8
    
    var board : [[Piece?]] = [[Piece?]](repeating: [Piece?](repeating: nil, count: 8), count: 8)
    @Published var turn : PieceColor = .white
    
    enum CodingKeys: CodingKey {
        case board, turn
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(board, forKey: .board)
        try container.encode(turn, forKey: .turn)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        board = try container.decode([[Piece?]].self, forKey: .board)
        for i in 0..<row{
            for j in 0..<col{
                if let piece = self[i, j] {
                    switch piece.name{
                        case .king: self[i, j] = King(piece)
                        case .queen: self[i, j] = Queen(piece)
                        case .rook: self[i, j] = Rook(piece)
                        case .bishop: self[i, j] = Bishop(piece)
                        case .knight: self[i, j] = Knight(piece)
                        case .pawn: self[i, j] = Pawn(piece)
                    }
                }
            }
        }
        turn = try container.decode(PieceColor.self, forKey: .turn)
    }
    
    init(board: Board){
        for i in 0..<row{
            for j in 0..<col{
                if let piece = board[i, j] {
                    switch piece.name{
                        case .king: self[i, j] = King(piece)
                        case .queen: self[i, j] = Queen(piece)
                        case .rook: self[i, j] = Rook(piece)
                        case .bishop: self[i, j] = Bishop(piece)
                        case .knight: self[i, j] = Knight(piece)
                        case .pawn: self[i, j] = Pawn(piece)
                    }
                }
            }
        }
        self.turn = board.turn
    }
    
    init(_ dontInitPieces: Bool = false, asWhite: Bool = true){
        
        if (dontInitPieces) {
            return
        }
            
        //pawns
        for i in 0...7{
            board[1][i] = Pawn("bp")
            board[6][i] = Pawn("wp")
        }
        
        //black side
        board[0][0] = Rook("br")
        board[0][7] = Rook("br")
        board[0][1] = Knight("bn")
        board[0][6] = Knight("bn")
        board[0][2] = Bishop("bb")
        board[0][5] = Bishop("bb")
        board[0][3] = Queen("bq")
        board[0][4] = King("bk")
        
        //white side
        board[7][0] = Rook("wr")
        board[7][7] = Rook("wr")
        board[7][1] = Knight("wn")
        board[7][6] = Knight("wn")
        board[7][2] = Bishop("wb")
        board[7][5] = Bishop("wb")
        board[7][3] = Queen("wq")
        board[7][4] = King("wk")
        
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

extension Board{
    
    func hash(into hasher: inout Hasher) {
        for i in 0...7{
            for j in 0...7{
                if let piece = self[i, j]?.hashValue{
                    hasher.combine(piece.hashValue)
                    hasher.combine(i)
                    hasher.combine(j)
                }
            }
        }
        hasher.combine(self.turn)
    }
    
    static func ==(lhs: Board, rhs: Board) -> Bool{
        return lhs.hashValue == rhs.hashValue
//        for i in 0...7{
//            for j in 0...7{
//                if (lhs[i, j] != rhs[i, j]) {
//                    return false
//                }
//            }
//        }
//        return true
    }
    
    var flipped : Int{
        1
    }
    
    var size : Double{
        min(screenWidth, maxBoardSize)
    }
    
    var sizeq : Double {
        Double(size)/Double(col)
    }
    
    @inline(__always)
    subscript (i: Int, j : Int) -> Piece? {
        get{
            return self.board[i][j]
        }
        set{
            self.board[i][j] = newValue
        }
    }
    
    @inline(__always)
    subscript (i: Int) -> [Piece?] {
        get{
            return self.board[i]
        }
        set{
            self.board[i] = newValue
        }
    }
    
    @inline(__always)
    subscript (at : Position) -> Piece?{
        get{
            return self.board[at.x][at.y]
        }
        set{
            self.board[at.x][at.y] = newValue
        }
    }
    
    //checks if this board is valid i.e. does not leave the king open or is against the law
    func isValid() -> Bool{
        for i in board.indices{
            for j in board[i].indices{
                if let piece = board[i][j]{
                    let pos = Position(i, j)
                    //we dont need to check for opposite colors since the only way a piece's possible moves is not nil is that the occupying piece is of opposite color already
                    if piece.possibleMoves(at: pos, board: self).contains(where: {
                        return self[$0] != nil && self[$0]?.name == .king && self[$0]?.color == turn
                    }){
                        return false
                    }
                }
            }
        }
        return true
    }
    
    //checks if there is a possible move i.e. game hasnt ended
    func hasPossibleMove() -> Bool{
        for i in board.indices{
            for j in board[i].indices{
                if let piece = board[i][j]{
                    let pos = Position(i, j)
                    if (piece.color == turn && !piece.possibleMoves(at: pos, board: self).isEmpty){
                        return true
                    }
                }
            }
        }
        return false
    }

}
