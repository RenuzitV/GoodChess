//
//  Stage.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation
import SwiftUI

struct MoveInfo: Equatable{
    var ok : Bool
    var captured : Bool
}

struct Move: Codable, Equatable{
    var from : Position
    var to : Position
    var first : Bool = false
    var pieceFrom : Piece? = nil
    var pieceTo : Piece? = nil
    
    enum CodingKeys: CodingKey {
        case from, to
    }
    
    init(from: Position, to: Position){
        self.from = from
        self.to = to
    }
    
    init(_ from: Position, _ to: Position, _ pieceFrom: Piece?, _ pieceTo: Piece?){
        self.from = from
        self.to = to
        self.pieceFrom = pieceFrom
        self.first = pieceFrom?.firstMove ?? false
        self.pieceTo = pieceTo
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        from = try container.decode(Position.self, forKey: .from)
        to = try container.decode(Position.self, forKey: .to)
    }
}

enum BotDifficulty: String, Codable, Equatable, CaseIterable {
    case easy
    case medium
    case hard
    case hardest
    case buggy
    
}

func toBotDiffString( _ diff: BotDifficulty) -> String{
    switch diff{
    case .easy:
        return "Easy"
    case .medium:
        return "Medium"
    case .hard:
        return "Hard"
    case .hardest:
        return "Hardest"
    case .buggy:
        return "Buggy"
//    default:
//        return "Easy"
    }
}

func toBotDiffEnum( _ diff: String) -> BotDifficulty{
    switch diff{
    case "Easy":
        return .easy
    case "Medium":
        return .medium
    case "Hard":
        return .hard
    case "Hardest":
        return .hardest
    case "Buggy":
        return .buggy
    default:
        return .easy
    }
}

func pieceTypeToIndex(_ piece: Piece) -> (typeIndex: Int, colorIndex: Int) {
    let typeIndex: Int
    switch piece.name {
        case .king: typeIndex = 0
        case .queen: typeIndex = 1
        case .rook: typeIndex = 2
        case .bishop: typeIndex = 3
        case .knight: typeIndex = 4
        case .pawn: typeIndex = 5
    }

    let colorIndex = piece.color == .white ? 0 : 1
    return (typeIndex, colorIndex)
}

enum GameState: Codable, Equatable{
    case none
    case playing
    case p1w
    case p2w
    case stalemate
    case draw
}

class Stage: ObservableObject, Codable, Identifiable, Equatable{
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
    @Published var zobristTable: [[[UInt64]]] = [[[UInt64]]](repeating: [[UInt64]](repeating: [UInt64](repeating: 0, count: 64), count: 2), count: 6)
    @Published var boardHash: UInt64 = 0

    var ai = AILogic()
    var pseudoRandomGenerator = SeededGenerator(seed: 123456789) // Fixed seed

//    @Published var showLastMove: Move? = nil
//    @Published var showMoves: [Position] = []
//    @Published var showChosenPiecePosition : Position? = nil
    
    var lastMoves: [Move] = []
    
    enum CodingKeys: CodingKey {
        case board, versusBot, botDifficulty, player1, player2, gameState, lastMove, zobristTable, boardHash
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
        try container.encode(zobristTable, forKey: .zobristTable)
        try container.encode(boardHash, forKey: .boardHash)
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
        do {
            lastMove = try container.decode(Move.self, forKey: .lastMove)
        } catch{
            lastMove = nil
        }
        zobristTable = try container.decode([[[UInt64]]].self, forKey: .zobristTable)
        boardHash = try container.decode(UInt64.self, forKey: .boardHash)
    }
    
    init(_ dontload: Bool = false) {
        if (dontload){
            return
        }
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
        self.zobristTable = stage.zobristTable
        self.boardHash = stage.boardHash
    }
}

extension Stage{
    
    static func ==(lhs: Stage, rhs: Stage) -> Bool{
        return
            lhs.board == rhs.board &&
            lhs.versusBot == rhs.versusBot &&
            lhs.botDifficulty  == rhs.botDifficulty &&
            lhs.player1 == rhs.player1 &&
            lhs.player2 == rhs.player2 &&
            lhs.gameState == rhs.gameState &&
            lhs.possibleMoves == rhs.possibleMoves &&
            lhs.chosenPiecePosition == rhs.chosenPiecePosition &&
            lhs.lastMove == rhs.lastMove
    }
    
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
            self.zobristTable = stage.zobristTable
            self.boardHash = stage.boardHash
        } else{
            loadNewStage()
        }
    }
    
    func xorTable(x: Int, y: Int, piece: Piece?){
        if let p = piece{
            let (typeIndex, colorIndex) = pieceTypeToIndex(p)
            self.boardHash ^= zobristTable[typeIndex][colorIndex][x * 8 + y]
        }
    }
    
    func xorTable(at: Position, piece: Piece?){
        xorTable(x: at.x, y: at.y, piece: piece)
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
        self.lastMoves = []
        
        // Assuming 6 piece types and 2 colors
        self.zobristTable = [[[UInt64]]](repeating: [[UInt64]](repeating: [UInt64](repeating: 0, count: 64), count: 2), count: 6)
        for i in 0..<6 {
            for j in 0..<2 {
                for k in 0..<64 {
                    self.zobristTable[i][j][k] = UInt64.random(in: UInt64.min...UInt64.max, using: &pseudoRandomGenerator)
                }
            }
        }
        
        // Calculate initial hash value
        self.boardHash = 0
        for x in 0..<8 {
            for y in 0..<8 {
                if let piece = self.board[x, y] {
                    xorTable(x: x, y: y, piece: piece)
                }
            }
        }        
        
        self.ai = AILogic()
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
    
    func startGame(versusBot: Bool, player1: String, player2: String = "Bot ", botDifficulty: BotDifficulty = .easy){
        self.loadNewStage()
        self.gameState = .playing
        self.versusBot = versusBot
        self.botDifficulty = botDifficulty
        self.player1 = player1
        if (self.versusBot == true){
            self.player2 = "Bot (\(toBotDiffString(self.botDifficulty)))"
        } else {
            self.player2 = player2
        }
    }
    
    func getPlayerPiecePositions() -> [Position]{
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
        return positions
    }
    
    
    //MARK: calc possible pos
    //checks if the clicked position has any piece, and calculates the possible moves that that move can make
    //ugly returns all positions, including positions to move that is invalid
    @discardableResult
    func calcPossiblePositions(from : Position, ugly: Bool = false) -> [Position]{
        if let piece = board[from]{
            //if that piece's color is different from the current player turn's color
            //or that piece is the same as the previous chosen piece,
            //reset the moves
            if (piece.color != board.turn || (chosenPiecePosition != nil && piece === board[chosenPiecePosition!]!)) {
                resetMoves()
                return []
            }
            
            //make a move from a piece's possible moves, and checks if the board state is valid
            possibleMoves = piece.possibleMoves(at: from, board: board).filter({
                if (ugly) {
                    return true
                }
                move(from: from, to: $0)
                let res = self.board.isValid()
                undoMove()
                return res
            })
            
            //castling
            if (piece.name == .king && piece.firstMove){
                if let firstRook = board[from.x, 0], firstRook.firstMove && board[from.x, from.y - 1] == nil && board[from.x, from.y - 2] == nil && board[from.x, from.y - 3] == nil {
                    board[from.x, from.y - 1] = board[from]
                    board[from.x, from.y - 2] = board[from]
                    if (board.isValid()){
                        possibleMoves.append(Position(from.x, from.y - 2))
                    }
                    board[from.x, from.y - 1] = nil
                    board[from.x, from.y - 2] = nil
                }
                if let firstRook = board[from.x, 7], firstRook.firstMove && board[from.x, from.y + 1] == nil && board[from.x, from.y + 2] == nil {
                    board[from.x, from.y + 1] = board[from]
                    board[from.x, from.y + 2] = board[from]
                    if (board.isValid()){
                        possibleMoves.append(Position(from.x, from.y + 2))
                    }
                    board[from.x, from.y + 1] = nil
                    board[from.x, from.y + 2] = nil
                }
            }
            //castling
            
            chosenPiecePosition = from
        }
        else {
            resetMoves()
        }
        return possibleMoves
    }
    
    //MARK: calc possible moves
    //ugly returns all moves, including moves that is invalid
    @discardableResult
    func calcPossibleMoves(ugly: Bool = false) -> [Move]{
        var res: [Move] = []
        for position in getPlayerPiecePositions() {
            chosenPiecePosition = nil
            let possibleToPossitions = calcPossiblePositions(from: position, ugly: ugly)
            possibleToPossitions.forEach({
                res.append(Move(from: position, to: $0))
            })
        }
        return res
    }
    
    //MARK: undo move
    func undoMove(switchTurns: Bool = false){
        if let move = lastMoves.popLast() {
            //remove piece that is currently at from
            xorTable(at: move.from, piece: board[move.from])
            board[move.from] = move.pieceFrom
            //add piece that is now at from
            xorTable(at: move.from, piece: board[move.from])
            board[move.from]?.firstMove = move.first
            //remove piece that is currently at to
            xorTable(at: move.to, piece: board[move.to])
            board[move.to] = move.pieceTo
            xorTable(at: move.to, piece: board[move.to])
            
            //castle
            if let piece = board[move.from] {
                if (piece.name == .king && move.to.y - move.from.y > 1){
                    //remove piece that was at (from.x, 7)
                    xorTable(x: move.from.x, y: 7, piece: board[move.from.x, 7])
                    board[move.from.x, 7] = Rook(piece.color == .black ? "br" : "wr")
                    //add rook at (from.x, 7)
                    xorTable(x: move.from.x, y: 7, piece: board[move.from.x, 7])
                    
                    //remove piece at (to.x, to.y-1)
                    xorTable(x: move.to.x, y: move.to.y-1, piece: board[move.to.x, move.to.y-1])
                    board[move.to.x, move.to.y-1] = nil
                }
                else if (piece.name == .king && move.from.y - move.to.y > 1){
                    //remove piece that was at (from.x, 0)
                    xorTable(x: move.from.x, y: 0, piece: board[move.from.x, 0])
                    board[move.from.x, 0] = Rook(piece.color == .black ? "br" : "wr")
                    //add rook at (from.x, 0)
                    xorTable(x: move.from.x, y: 0, piece: board[move.from.x, 0])
                    
                    
                    //remove piece at (to.x, to.y+1)
                    xorTable(x: move.to.x, y: move.to.y+1, piece: board[move.to.x, move.to.y+1])
                    board[move.to.x, move.to.y+1] = nil
                }
                
            }
            if (switchTurns){
                board.turn = board.turn == .white ? .black : .white
            }
            lastMove = lastMoves.last
        }
        resetMoves()
    }
    
    //MARK: move
    //moves a piece to the location, and takes whatever piece that was in that location
    @discardableResult
    func move(from: Position? = nil, to: Position) -> MoveInfo{
        
        //decides where the piece will move from, the default being chosenPiecePosition
        if (from == nil && chosenPiecePosition == nil) {
            return MoveInfo(ok: false, captured: false)
        }
        
        
        let fromm = from == nil ? chosenPiecePosition! : from!
                
        //ok to move, check if any piece is captured
        lastMoves.append(Move(fromm, to, board[fromm], board[to]))
        
        var moveInfo = MoveInfo(ok: true, captured: false)
        if board[to] != nil{
            moveInfo.captured = true
        }
        
        //moving the piece at fromm and capturing the piece at to
        let movingPiece = board[fromm]
        let capturedPiece = board[to]
        
        board[fromm] = nil
        board[to] = movingPiece
        
        //remove moving piece at from
        xorTable(at: fromm, piece: movingPiece)
        //remove captured piece at to
        xorTable(at: to, piece: capturedPiece)
        //add back moving piece at to
        xorTable(at: to, piece: movingPiece)
        
        
        //set firstMove to false if it isnt already
        board[to]?.firstMove = false
        
        //promote
        if (board[to]?.name == .pawn){
            let temp = board[to]!
            if (temp.color == .white){
                if ((board.flipped == 1 && to.x == 0) || (board.flipped == 0 && to.x == 7)) {
                    //remove moving piece at to
                    xorTable(at: to, piece: movingPiece)
                    board[to] = Queen("wq")
                    //add queen piece at to
                    xorTable(at: to, piece: board[to])
                }
            }
            else {
                if ((board.flipped == 1 && to.x == 7) || (board.flipped == 0 && to.x == 0)) {
                    //remove moving piece at to
                    xorTable(at: to, piece: movingPiece)
                    board[to] = Queen("bq")
                    //add queen piece at to
                    xorTable(at: to, piece: board[to])
                }
            }
        }
        
        //castle
        if (board[fromm] == nil && board[to]?.name == .king && to.y - fromm.y > 1){
            //remove rook at (fromm.x, 7)
            xorTable(x: fromm.x, y: 7, piece: board[fromm.x, 7])
            board[to.x, to.y-1] = board[fromm.x, 7]
            //add rook at (to.x, to.y-1)
            xorTable(x: to.x, y: to.y-1, piece: board[to.x, to.y-1])
            board[fromm.x, 7] = nil
        }
        if (board[fromm] == nil && board[to]?.name == .king && fromm.y - to.y > 1){
            //remove rook at (fromm.x, 0)
            xorTable(x: fromm.x, y: 0, piece: board[fromm.x, 0])
            board[to.x, to.y+1] = board[fromm.x, 0]
            //add rook at (to.x, to.y+1)
            xorTable(x: to.x, y: to.y+1, piece: board[to.x, to.y+1])
            board[fromm.x, 0] = nil
        }
        //castle
        
        return moveInfo
    }
    
    //MARK: makeMove
    //tries to move a piece to a position
    //calls resetMoves to reset the chosen piece selection
    //this function only resolves things that happens AFTER making a move
    //for ANY logic preceding a move, put in move()
    @discardableResult
    func makeMove(to: Position, sound: Bool = false) -> Move?{
        //get board as self.board, try to make the move, then assign self.board back in
        //checks if this is a possible move
        var moveInfo : MoveInfo = MoveInfo(ok: false, captured: false)
        var res : Move? = nil
        
        moveInfo = self.move(to: to)
        
        //if the move is valid
        if moveInfo.ok{
            
            res = Move(from: chosenPiecePosition!, to: to)
            
            //play capture/move sound
            if (sound){
                if (moveInfo.captured) {
                    playSound(sound: "Capture")
                }
                else{
                    playSound(sound: "Move")
                }
                
                //switch turns
                self.board.turn = self.board.turn == .white ? .black : .white
                
                resetMoves()
//            }
//                let _ = lastMoves.popLast()
            } else {
                undoMove()
            }
            
            return res
        }
        
        undoMove()
        resetMoves()
        return res
    }
    
    //checks if a move is possible
    @discardableResult
    func makeMovePossible(to: Position) -> Bool{
        //checks if this is a possible move
        let moveInfo = move(to: to)
        let res = moveInfo.ok
        undoMove()
        return res
    }
    
    func getBotMove(completion: @escaping (Move?) -> Void) {
        let stage = Stage(stage: self)
        
        switch botDifficulty {
        case .easy:
            completion(stage.getEasyBotMove())
        case .medium:
            completion(stage.getMediumBotMove())
        case .hard:
            completion(stage.getHardBotMove())
        case .hardest:
            stage.getHardestBotMove(completion: completion)
        case .buggy:
            completion(stage.getHardBotMove())
        // default case if needed
        }
    }
    
    func makeBotMove(move: Move){
        if botDifficulty == .buggy{
            wreckHavoc(move: move)
        }
        else {
            chosenPiecePosition = move.from
            makeMove(to: move.to, sound: true)
        }
        lastMove = move
    }
    
    //MARK: get Bot move
    ///
    ///Function to make an easy bot move
    ///This function retrieves all pieces of its color, iterates through them (shuffled) and makes a random move
    ///After finding a possible move, the functiorn returns.
    func getEasyBotMove() -> Move?{
        for position in getPlayerPiecePositions().shuffled() {
            chosenPiecePosition = nil
            calcPossiblePositions(from: position)
            let possibleToPossitions = possibleMoves.shuffled()
            if let pickedToPosition = possibleToPossitions.first,
               makeMove(to: pickedToPosition) != nil{
                    return Move(from: position, to: pickedToPosition)
            }
        }
        return nil
    }
    
    //MARK: get Medium/Buggy Bot move
    ///function to get a medium difficulty bot move
    func getMediumBotMove() -> Move?{
        
        //variable to save a move that takes a piece, so we can either do that move or make an easy bot move (random move)
        var possibleMove : Move? = nil
        
        for position in getPlayerPiecePositions().shuffled(){
            //successfully got piece, generating moves
            chosenPiecePosition = nil
            calcPossiblePositions(from: position)
            //shuffle to add randomness
            let possibleToPossitions = possibleMoves.shuffled()
            
            //for each possible position that the piece can move to

            for possibleToPosition in possibleToPossitions{
                //checks if the move is possible or not (does not move outside or takes a piece of the same color)
                if (makeMove(to: possibleToPosition) != nil){
                    
                    //checks if the move takes any piece
                    //if so, save that move
                    if (board[possibleToPosition] != nil){
                        possibleMove = Move(from: position, to: possibleToPosition)
                    }
                    
                    chosenPiecePosition = nil
                    
                    // simulate the piece being moved, and checks if that move also checks the enemy king
                    
                    //save the taken piece
                    let takenPiece = board[possibleToPosition] as Piece?
                    
                    board[possibleToPosition] = board[position]
                    
                    calcPossiblePositions(from: possibleToPosition)
                    
                    //put the taken piece to where it was
                    board[possibleToPosition] = takenPiece
                    
                    //if after moving to possibleMovePosition, the piece also checks the enemy king
                    if (possibleMoves.contains(where: {
                        board[$0]?.name == .king && board[$0]?.color != board[position]?.color
                    })){
                        //use this move instead
                        if (botDifficulty == .medium) {
                            return Move(from: position, to: possibleToPosition)
                        }
                    }
                }
            }
        }
        
        //use this move instead
        if let move = possibleMove{
            return move
        }
        return getEasyBotMove()
    }
    
    //MARK: STUPID GOOD AI COPIED FROM INTERNET???!?!!!
    func getHardBotMove() -> Move?{
        if let move = self.ai.getBestMove(stage: self) {
            return move
        }
        return nil
    }
    
    //MARK: lichess, gg
    func getHardestBotMove(completion: @escaping (Move?) -> Void) {
        let fenString = boardToFEN(board: self.board)
        
        fetchBestMoveFromLichess(fen: fenString) { move in
            if let move = move {
                completion(move)
            } else {
                // Fallback to the hard bot move if Lichess response is null or an error occurs
                print("cannot get move from api, defaulting to hard bot move")
                completion(self.getHardBotMove())
            }
        }
    }


    
    //MARK: WRECK HAVOC
    ///This function does exactly what is says
    ///be careful
    @discardableResult
    func wreckHavoc(move : Move) -> Move?{
        chosenPiecePosition = nil
        calcPossiblePositions(from: move.from)
        for possibleMove in possibleMoves.filter({ board[$0]?.color != board[move.from]?.color }){
            board[possibleMove] = nil
        }
        chosenPiecePosition = move.from
        return makeMove(to: move.to, sound: true)
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
                        calcPossiblePositions(from: position)
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
    
    //MARK: RESOLVE CLICK
    //resolves whether we should try to make a move or calculate possible moves
    func resolveClick(at: Position){
        if (possibleMoves.contains(where: {$0 == at})){
            lastMove = makeMove(to: at, sound: true)
            gameState = checkGameState()
            save()
            print("current board hash: \(board.hashValue)")
            print("zobrist board hash: \(self.boardHash)")
            resetMoves()
//            resetShowingMoves()
        }
        else{
            calcPossiblePositions(from: at)
//            if (showChosenPiecePosition == at) {
//                showChosenPiecePosition = nil
//            } else {
//                showChosenPiecePosition = self.board[at]?.color == self.board.turn ? at : nil
//            }
        }
    }
    
//    //reset chosenPiecePosition and possibleMoves so players can cancel chossing a piece
//    func resetShowingMoves(){
//        showChosenPiecePosition = nil
//        showMoves = []
//    }
    
    //reset chosenPiecePosition and possibleMoves so players can cancel chossing a piece
    func resetMoves(){
        chosenPiecePosition = nil
        possibleMoves = []
    }
}
