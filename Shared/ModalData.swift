//
//  ModalData.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 17/08/2022.
//

import Foundation
import SwiftUI
import AVFAudio

public var backgroundColor: Color {
    Color(0xf2c363).opacity(0.2)
}

func load<T: Decodable>(_ filename: String) -> T? {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        let decoded : T = try decoder.decode(T.self, from: data)
        print("loaded from \(filename) sucessfully.")
        return decoded
    } catch {
        print("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    return nil
}

func save<T: Encodable>(_ filename: String,_ data: T){

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedData = try encoder.encode(data)
        try encodedData.write(to: file)
        print("wrote to \(filename) sucessfully.")
        //debug
//        print(String(data: encodedData, encoding: .utf8))
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

var boardViewWithKingMoves: StaticBoardView{
    let res = Board(true)
    let stage = Stage(true)
    res[4, 4] = King("wk")
    res[6, 0] = Bishop("bb")
    res[5, 0] = Rook("br")
    stage.board = res
    var possibleMoves = stage.calcPossiblePositions(from: Position(4, 4))
    return StaticBoardView(board: res, possibleMoves: possibleMoves)
}

var boardViewWithQueenMoves: StaticBoardView{
    let res = Board(true)
    let stage = Stage(true)
    res[4, 4] = Queen("wq")
    res[4, 2] = Bishop("wb")
    res[2, 4] = Pawn("bp")
    res[2, 2] = Knight("bn")
    stage.board = res
    return StaticBoardView(board: res, possibleMoves: stage.calcPossiblePositions(from: Position(4, 4)))
}

var boardViewWithRookMoves: StaticBoardView{
    let res = Board(true)
    let stage = Stage(true)
    res[4, 4] = Rook("wr")
    stage.board = res
    return StaticBoardView(board: res, possibleMoves: stage.calcPossiblePositions(from: Position(4, 4)))
}

var boardViewWithKnightMoves: StaticBoardView{
    let res = Board(true)
    let stage = Stage(true)
    res[4, 4] = Knight("wn")
    stage.board = res
    return StaticBoardView(board: res, possibleMoves: stage.calcPossiblePositions(from: Position(4, 4)))
}

var boardViewWithBishopMoves: StaticBoardView{
    let res = Board(true)
    let stage = Stage(true)
    res[4, 4] = Bishop("wb")
    res[4, 1] = Bishop("wb")
    stage.board = res
    var possibleMoves = stage.calcPossiblePositions(from: Position(4, 4))
    possibleMoves.append(contentsOf: stage.calcPossiblePositions(from: Position(4, 1)))
    return StaticBoardView(board: res, possibleMoves: possibleMoves)
}

var boardViewWithPawnMoves: StaticBoardView{
    let res = Board(true)
    let stage = Stage(true)
    res[6, 6] = Pawn("wp")
    res[5, 5] = Pawn("wp")
    res[5, 5]?.firstMove = false
    res[4, 1] = Pawn("wp")
    res[4, 1]?.firstMove = false
    res[3, 2] = Pawn("bp")
    res[3, 2]?.firstMove = false
    stage.board = res
    var possibleMoves = stage.calcPossiblePositions(from: Position(6, 6))
    possibleMoves.append(contentsOf: stage.calcPossiblePositions(from: Position(5, 5)))
    possibleMoves.append(contentsOf: stage.calcPossiblePositions(from: Position(4, 1)))
    possibleMoves.append(contentsOf: stage.calcPossiblePositions(from: Position(3, 2)))
    return StaticBoardView(board: res, possibleMoves: possibleMoves)
}

var boardViewWithCheckmatedKing: StaticBoardView{
    let res = Board(true)
    res[0, 7] = King("bk")
    res[5, 7] = Queen("wq")
    res[4, 6] = Rook("wr")
    return StaticBoardView(board: res, possibleMoves: [])
}

var boardViewWithPawnAlmostPromote: StaticBoardView{
    let res = Board(true)
    let stage = Stage(true)
    res[1, 4] = Pawn("wp")
    stage.board = res
    return StaticBoardView(board: res, possibleMoves: stage.calcPossiblePositions(from: Position(1, 4)))
}

var boardViewWithPromotedPawn: StaticBoardView{
    let res = Board(true)
    res[0, 4] = Queen("wq")
    return StaticBoardView(board: res, possibleMoves: [])
}

var boardViewWithKingAlmostCastle: StaticBoardView{
    let res = Board(true)
    let stage = Stage(true)
    res[7, 4] = King("wk")
    res[7, 0] = Rook("wr")
    res[7, 7] = Rook("wr")
    stage.board = res
    let possibleMoves = stage.calcPossiblePositions(from: Position(7, 4))
    return StaticBoardView(board: res, possibleMoves: possibleMoves)
}

var boardViewWithQueenSideCastle: StaticBoardView{
    let res = Board(true)
    res[7, 2] = King("wk")
    res[7, 3] = Rook("wr")
    res[7, 7] = Rook("wr")
    return StaticBoardView(board: res, possibleMoves: [])
}

var boardViewWithKingSideCastle: StaticBoardView{
    let res = Board(true)
    res[7, 6] = King("wk")
    res[7, 0] = Rook("wr")
    res[7, 5] = Rook("wr")
    return StaticBoardView(board: res, possibleMoves: [])
}

