//
//  Pawn.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation

class Knight: Piece{
    
    override func possibleMoves(at: Position, board: Board) -> [Position] {
        var res : [Position] = [Position(2, 1), Position(1, 2), Position(2, -1), Position(1, -2), Position(-2, -1), Position(-1, -2), Position(-2, 1), Position(-1, 2)]
        res.indices.forEach({
            res[$0] += at
        })
        res = res.filter({($0).inBounds() && (board[$0] == nil || board[$0]!.color != self.color)})
        return res
    }
}
