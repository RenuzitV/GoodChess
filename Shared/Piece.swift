//
//  Piece.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//
//https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language

import Foundation
import SwiftUI

enum PieceType: Codable{
    case king
    case queen
    case rook
    case bishop
    case knight
    case pawn
}

enum PieceColor: Codable{
    case white
    case black
}

struct Position: Codable{
    var x : Int
    var y : Int
    
    init(_ x: Int, _ y: Int){
        self.x = x
        self.y = y
    }
    
    func equals(to : Position) -> Bool{
        return x == to.x && y == to.y
    }
    
    func equals(x: Int, y: Int) -> Bool{
        return self.x == x && self.y == y
    }
    
    func inBounds() -> Bool{
        return 0 <= x && x < 8 && 0 <= y && y < 8
    }
    
    static func +(lhs: Position, rhs: Position) -> Position{
        return Position(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    static func +=(lhs: inout Position, rhs: Position){
        lhs = lhs + rhs
    }
    
    static func !=(lhs: Position, rhs: Position) -> Bool{
        return lhs.x != rhs.x || lhs.y != rhs.y
    }
    static func ==(lhs: Position, rhs: Position) -> Bool{
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class Piece: Codable{
    var name : PieceType
    var color : PieceColor
    var path : String
    var firstMove = true
    
    init(pieceName : String = "bp"){
        self.color = pieceName[0] == "w" ? .white : .black
        self.path = pieceName
        
        switch pieceName[1] {
        case "k" :
            name = .king
            break
        case "q" :
            name = .queen
            break
        case "r" :
            name = .rook
            break
        case "b" :
            name = .bishop
            break
        case "n" :
            name = .knight
            break
        case "p" :
            name = .pawn
            break
        default:
            name = .pawn
            self.path = "bp"
            break
        }
    }
    
    func possibleMoves(at : Position, board: Board) -> [Position]{
        var res : [Position] = []
        for i in 0..<8{
            for j in 0..<8{
                res.append(Position(i, j))
            }
        }
        return res
    }
    
    static let example = Piece(pieceName: "br")
}
