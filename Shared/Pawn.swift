//
//  Pawn.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation

class Pawn: Piece{
    
    override func possibleMoves(at: Position, board: Board) -> [Position] {
        let dir : Int
        if (self.color == .white && board.flipped == 1) || (self.color == .black && board.flipped == 0){
            dir = -1
        }
        else {
            dir = 1
        }
        
        var res = [Position(x: at.x + dir, y: at.y)]
        
        if (res[0].inBounds() && board[res[0]] == nil){
            if (firstMove){
                res.append(Position(x: at.x + dir*2, y: at.y))
                if (res[1].inBounds() && board[res[1]] != nil){
                    res.remove(at: 1)
                }
            }
        }
        else {
            res.remove(at: 0)
        }
        
        var temp = at + Position(x: dir, y: -1)
        if (temp.inBounds() && board[temp] != nil && board[temp]!.color != self.color){
            res.append(temp)
        }
        
        temp = at + Position(x: dir, y: 1)
        if (temp.inBounds() && board[temp] != nil && board[temp]!.color != self.color){
            res.append(temp)
        }
        return res
    }
}
