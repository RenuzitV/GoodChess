//
//  Pawn.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation

class Rook: Piece{
    
    override func possibleMoves(at : Position, board: Board) -> [Position] {
        let directions : [Position] = [Position(1, 0), Position(-1, 0), Position(0, 1), Position(0, -1)]
        var res : [Position] = []
        
        for dir in directions{
            var temp = at + dir
            //while in bounds
            while (temp.inBounds()){
                //if there is a piece in way
                if let piece = board[temp]{
                    //if its the same color, we cant move anymore
                    if (piece.color == self.color) {
                        break
                    }
                    //otherwise, we can still take it can break
                    else {
                        res.append(temp)
                        break
                    }
                }
                //otherwise, this is a possible move
                res.append(temp)
                temp += dir
            }
        }
        return res
    }
}
