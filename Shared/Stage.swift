//
//  Stage.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation
import SwiftUI

struct Stage{
    @State var possibleMoves : [Position] = []
    @State var board : Board = Board()
    
    func calcPossibleMoves(from : Position){
        if let piece = board[from.x, from.y]{
            possibleMoves = piece.possibleMoves(board: board)
        }
    }
    
}
