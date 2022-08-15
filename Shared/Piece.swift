//
//  Piece.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//
//https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language

import Foundation
import SwiftUI

enum PieceType{
    case king
    case queen
    case rook
    case bishop
    case knight
    case pawn
}

enum PieceColor{
    case white
    case black
}

struct Position{
    var x : Int
    var y : Int
}

struct Piece{
    var name : PieceType
    var color : PieceColor
    var path : String
    
    init(pieceName : String){
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
    
    static let example = Piece(pieceName: "br")
}
