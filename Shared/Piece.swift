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

enum PieceColor: Codable, Equatable{
    case white
    case black
}

struct Position: Codable, Equatable{
    var x : Int = 0
    var y : Int = 0
    
    init(_ x: Int, _ y: Int){
        self.x = x
        self.y = y
    }
    
    init(){ }
    
    enum CodingKeys: CodingKey {
        case x, y
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        x = try container.decode(Int.self, forKey: .x)
        y = try container.decode(Int.self, forKey: .y)
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

class Piece: Codable, Equatable, Identifiable, Hashable{
    var id = UUID()
    var pos = 0
    var name : PieceType
    var color : PieceColor
    var path : String
    var firstMove = true
    
    init(_ pieceName : String = "wp"){
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
            self.path = "wp"
            break
        }
        
        self.firstMove = true
    }
    
    init(_ piece: Piece){
        self.name = piece.name
        self.color = piece.color
        self.path = piece.path
        self.firstMove = piece.firstMove
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
        
    static let example = Piece("br")
}

extension Piece{
    
    //a piece's color and name derives from its path, so we do not need to have them
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.path)
        hasher.combine(self.firstMove)
    }
    
    static func ==(lhs: Piece, rhs: Piece) -> Bool{
        return
            lhs.name == rhs.name &&
            lhs.color == rhs.color &&
            lhs.path == rhs.path &&
            lhs.firstMove == rhs.firstMove
    }
}
