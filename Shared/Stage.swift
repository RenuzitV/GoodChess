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

struct Move: Codable{
    var from : Position
    var to : Position
}

enum BotDifficulty: Codable {
    case easy
    case medium
    case hard
}

enum GameState: Codable{
    case none
    case playing
    case p1w
    case p2w
    case stalemate
    case draw
}

class Stage: ObservableObject, Codable, Identifiable{
    var id : UUID = UUID()
    @Published var board : Board = Board()
    @Published var versusBot : Bool = false
    @Published var botDifficulty: BotDifficulty = .easy
    @Published var player1: String = "Player 1"
    @Published var player2: String = "Player 2"
    @Published var gameState: GameState = .none
    @Published var possibleMoves : [Position] = []
    @Published var chosenPiecePosition : Position? = nil
    @Published var lastMove: Move? = nil
    
    enum CodingKeys: CodingKey {
        case board, versusBot, botDifficulty, player1, player2, gameState, lastMove
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(board, forKey: .board)
        try container.encode(versusBot, forKey: .versusBot)
        try container.encode(botDifficulty, forKey: .botDifficulty)
        try container.encode(player1, forKey: .player1)
        try container.encode(player2, forKey: .player2)
        try container.encode(gameState, forKey: .gameState)
        try container.encode(lastMove, forKey: .lastMove)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        board = try container.decode(Board.self, forKey: .board)
        versusBot = try container.decode(Bool.self, forKey: .versusBot)
        botDifficulty = try container.decode(BotDifficulty.self, forKey: .botDifficulty)
        player1 = try container.decode(String.self, forKey: .player1)
        player2 = try container.decode(String.self, forKey: .player2)
        gameState = try container.decode(GameState.self, forKey: .gameState)
        possibleMoves = []
        chosenPiecePosition = nil
        lastMove = try container.decode(Move.self, forKey: .lastMove)
    }
    
    init() {
        loadStage()
    }
    init(stage: Stage){
        self.board = Board(board: stage.board)
        self.versusBot = stage.versusBot
        self.botDifficulty  = stage.botDifficulty
        self.player1 = stage.player1
        self.player2 = stage.player2
        self.gameState = stage.gameState
        self.possibleMoves = stage.possibleMoves
        self.chosenPiecePosition = stage.chosenPiecePosition
        self.lastMove = stage.lastMove        
    }
}

extension Stage{
    
    func save(){
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let encodedData = try encoder.encode(self)
            UserDefaults.standard.set(encodedData, forKey: "Stage")
            print("wrote to Stage UserDefaults sucessfully.")
            //debug
    //        print(String(data: encodedData, encoding: .utf8))
        } catch {
            fatalError("Couldn't parse \(self):\n\(error)")
        }
    }
    
    func load(){
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: "Stage") as? Data,
        let stage : Stage = try? decoder.decode(Stage.self, from: data){
            print("loaded Stage from UserDefaults sucessfully.")
            loadStage(stage)
        }
    }
    
    func loadStage(_ stage: Stage? = nil){
        if let stage = stage ?? loadFromUserDefaults() ?? nil{
            self.board = Board(board: stage.board)
            self.versusBot = stage.versusBot
            self.botDifficulty  = stage.botDifficulty
            self.player1 = stage.player1
            self.player2 = stage.player2
            self.gameState = stage.gameState
            self.possibleMoves = stage.possibleMoves
            self.chosenPiecePosition = stage.chosenPiecePosition
            self.lastMove = stage.lastMove
        } else{
            self.board = Board()
            self.versusBot = false
            self.botDifficulty  = .easy
            self.player1 = "Player 1"
            self.player2 = "Player 2"
            self.gameState = .none
            self.possibleMoves = []
            self.chosenPiecePosition = nil
            self.lastMove = nil
        }
    }
    
    func loadNewStage(){
        self.board = Board()
        self.versusBot = false
        self.botDifficulty  = .easy
        self.player1 = "Player 1"
        self.player2 = "Player 2"
        self.gameState = .none
        self.possibleMoves = []
        self.chosenPiecePosition = nil
        self.lastMove = nil
    }
    
    func loadFromUserDefaults() -> Stage?{
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: "Stage") as? Data,
        let stage : Stage = try? decoder.decode(Stage.self, from: data){
            print("loaded from Stage UserDefaults sucessfully.")
            return stage
        }
        return nil
    }
    
    func startGame(versusBot: Bool, player1: String, player2: String){
        gameState = .playing
        self.versusBot = versusBot
        self.player1 = player1
        self.player2 = player2
    }
    

    //checks if the clicked position has any piece, and calculates the possible moves that that move can make
    func calcPossibleMoves(from : Position){
        if let piece = board[from]{
            //if that piece's color is different from the current player turn's color
            //or that piece is the same as the previous chosen piece,
            //reset the moves
            if (piece.color != board.turn || (chosenPiecePosition != nil && piece === board[chosenPiecePosition!]!)) {
                resetMoves()
                return
            }
            //make a move from a piece's possible moves, and checks if the board state is valid
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
    @discardableResult
    func move(from: Position? = nil, to: Position,  board: inout Board?) -> MoveInfo{
        
        //decides where the piece will move from, the default being chosenPiecePosition
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
        
        //decides which Board to change, the default being self.board
        //also duplicates the board in order to move stuff around
        let boardd : Board
        
        if (board == nil) {
            boardd = Board(board: self.board)
        }
        else {
            boardd = Board(board: board!)
        }
        
        //ok to move, check if any piece is captured
        var moveInfo = MoveInfo(ok: true, captured: false)
        if boardd[to] != nil{
            moveInfo.captured = true
        }
        boardd[to] = boardd[fromm!]
        boardd[fromm!] = nil
        
        //promote
        if (boardd[to]!.name == .pawn){
            let temp = boardd[to]!
            if (temp.color == .white){
                if ((boardd.flipped == 1 && to.x == 0) || (boardd.flipped == 0 && to.x == 7)) {
                    boardd[to] = Queen(pieceName: "wq")
                }
            }
            else {
                if ((boardd.flipped == 1 && to.x == 7) || (boardd.flipped == 0 && to.x == 0)) {
                    boardd[to] = Queen(pieceName: "bq")
                }
            }
        }
        
        //put the board back
        if (board == nil) {
            self.board = boardd
        }
        else {
            board = boardd
        }
        
        return moveInfo
    }
    
    //tries to move a piece to a position
    //calls resetMoves to reset the chosen piece selection
    //this function only resolves things that happens AFTER making a move
    //for ANY logic preceding a move, put in move()
    @discardableResult
    func makeMove(to: Position, sound: Bool = false) -> Move?{
        //get board as self.board, try to make the move, then assign self.board back in
        var temp = self.board as Board?
        //checks if this is a possible move
        let moveInfo = move(to: to, board: &temp)
        
        //if the move is valid
        if moveInfo.ok{
            //play capture/move sound
            if (moveInfo.captured && sound) {
                playSound(sound: "Capture")
            }
            else if (sound){
                playSound(sound: "Move")
            }
            
            //assign self.board back in
            self.board = temp!
            board[to]!.firstMove = false
            
            //switch turns
            self.board.turn = self.board.turn == .white ? .black : .white
            
            let res = Move(from: chosenPiecePosition!, to: to)
            resetMoves()
            return res
        }
        
        resetMoves()
        return nil
    }
    
    //checks if a move is possible
    @discardableResult
    func makeMovePossible(to: Position) -> Bool{
        var temp = self.board as Board?
        //checks if this is a possible move
        let moveInfo = move(to: to, board: &temp)
        return moveInfo.ok
    }
    
    func makeBotMove() -> Move?{
        var positions: [Position] = []
        for row in 0..<8{
            for col in 0..<8{
                if let piece = board[row, col]{
                    if (piece.color == board.turn) {
                        positions.append(Position(row, col))
                    }
                }
            }
        }
        positions.shuffle()
        for position in positions {
            chosenPiecePosition = nil
            calcPossibleMoves(from: position)
            let possibleToPossitions = possibleMoves.shuffled()
            if let pickedToPosition = possibleToPossitions.first {
                let hasPiece = board[pickedToPosition] != nil
                if (makeMove(to: pickedToPosition) != nil){
                    if (hasPiece) {
                        playSound(sound: "Capture")
                    }
                    else{
                        playSound(sound: "Move")
                    }
                    return Move(from: position, to: pickedToPosition)
                }
            }
        }
        return nil
    }
        
    func isChecked(board: Board? = nil) -> Bool{
        return !(board?.isValid() ?? self.board.isValid())
    }
    
    func checkGameState() -> GameState{
        for row in 0..<8{
            for col in 0..<8{
                if let piece = board[row, col]{
                    let position = Position(row, col)
                    if (piece.color == board.turn) {
                        chosenPiecePosition = nil
                        calcPossibleMoves(from: position)
                        for toPosition in possibleMoves{
                            if (makeMovePossible(to: toPosition)){
                                return .playing
                            }
                        }
                    }
                }
            }
        }
        if (!isChecked()) {
            return .stalemate
        }
        else {
            //if its black's turn and game has ended then white has won
            return board.turn == .black ? .p1w : .p2w
        }
    }
    
    //resolves whether we should try to make a move or calculate possible moves
    func resolveClick(at: Position){
        if (possibleMoves.contains(where: {$0 == at})){
            let temp = makeMove(to: at, sound: true)
            if (versusBot){
                lastMove = makeBotMove()
            }
            else {
                lastMove = temp!
            }
            gameState = checkGameState()
            resetMoves()
            save()
        }
        else{
            calcPossibleMoves(from: at)
        }
    }
    
    //reset chosenPiecePosition and possibleMoves so players can cancel chossing a piece
    func resetMoves(){
        chosenPiecePosition = nil
        possibleMoves = []
    }
}
