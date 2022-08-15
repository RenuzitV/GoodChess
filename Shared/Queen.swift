//
//  Pawn.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation

class Queen: Piece{
    
    //queen moves like both a bishop and a rook,both have no overlapping moves
    override func possibleMoves(at: Position, board: Board) -> [Position] {
        let bishop = Bishop()
        bishop.color = color
        let rook = Rook()
        rook.color = color
        var res = bishop.possibleMoves(at: at, board: board)
        res.append(contentsOf: rook.possibleMoves(at: at, board: board))
        return res
    }
}
