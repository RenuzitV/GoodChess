//
//  Stage.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation
import SwiftUI

struct MoveInfo{
    var ok : Bool
    var captured : Bool
}

class Stage: ObservableObject{
    @Published var possibleMoves : [Position] = []
    @Published var chosenPiecePosition : Position?
    @Published var board : Board = Board()
    
    func calcPossibleMoves(from : Position){
        if let piece = board[from]{
            possibleMoves = piece.possibleMoves(at: from, board: board).filter({
                var board = Board(board: self.board) as Board?
                move(from: from, to: $0, board: &board)
                return board!.isValid()
            })
            
            chosenPiecePosition = from
        }
        else {
            resetMoves()
        }
    }
    
    //moves a piece to the location, and takes whatever piece that was in that location
    func move(from: Position? = nil, to: Position,  board: inout Board?) -> MoveInfo{
        let fromm : Position?
        if (from == nil) {
            fromm = chosenPiecePosition
        }
        else {
            fromm = from
        }
        
        if (fromm == nil) {
            return MoveInfo(ok: false, captured: false)
        }
        
        let boardd : Board
        
        if board == nil {
            boardd = Board(board: self.board)
        }
        else {
            boardd = Board(board: board!)
        }
        
        var moveInfo = MoveInfo(ok: true, captured: false)
        if boardd[to] != nil{
            moveInfo.captured = true
        }
        boardd[to] = boardd[fromm!]
        boardd[fromm!] = nil
        
        if board == nil {
            self.board = boardd
        }
        else {
            board = boardd
        }
        
        return moveInfo
    }
    
    //tries to move a piece to a position
    func makeMove(to: Position) -> Bool{
        //checks if this is a possible move
        if (!possibleMoves.contains(where: {$0 == to})){
            return false
        }
        var temp = self.board as Board?
        let moveInfo = move(to: to, board: &temp)
        if moveInfo.ok{
            if moveInfo.captured {
                playSound(sound: "Capture")
            }
            else {
                playSound(sound: "Move")
            }
            self.board = temp!
            board[to]!.firstMove = false
        }
        
        resetMoves()
        self.board.turn = self.board.turn == .white ? .black : .white
        return true
    }
    
    func resetMoves(){
        chosenPiecePosition = nil
        possibleMoves = []
    }
}
