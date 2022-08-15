//
//  Pawn.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation

class Knight: Piece{
    
    override func possibleMoves(at: Position, board: Board) -> [Position] {
        var res : [Position] = [Position(x: 2, y: 1), Position(x: 1, y: 2), Position(x: 2, y: -1), Position(x: 1, y: -2), Position(x: -2, y: -1), Position(x: -1, y: -2), Position(x: -2, y: 1), Position(x: -1, y: 2)]
        res.indices.forEach({
            res[$0] += at
        })
        res = res.filter({($0).inBounds() && (board[$0] == nil || board[$0]!.color != self.color)})
        return res
    }
}
