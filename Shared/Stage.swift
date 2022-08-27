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
    case "Buggy":
        return .buggy
    default:
        return .easy
    }
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
    @Published var moved: Bool = false
    @Published var showMoves: [Position] = []
    
    var lastMoves: [Move] = []
    
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
        do {
            lastMove = try container.decode(Move.self, forKey: .lastMove)
        } catch{
            lastMove = nil
        }
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
    @discardableResult
    func calcPossiblePositions(from : Position) -> [Position]{
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
                move(from: from, to: $0, board: nil)
                let res = self.board.isValid()
                undoMove()
                return res
            })
            
            //castling
            if (piece.name == .king && piece.firstMove){
                if let firstRook = board[from.x, 0], firstRook.firstMove && board[from.x, from.y - 1] == nil && board[from.x, from.y - 2] == nil {
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
    @discardableResult
    func calcPossibleMoves() -> [Move]{
        var res: [Move] = []
        for position in getPlayerPiecePositions() {
            chosenPiecePosition = nil
            let possibleToPossitions = calcPossiblePositions(from: position)
            for toPossition in possibleToPossitions {
                if (makeMove(to: toPossition) != nil){
                    res.append(Move(from: position, to: toPossition))
                }
            }
        }
        return res
    }
    
    //MARK: undo move
    func undoMove(){
        if let move = lastMoves.popLast() {
            board[move.from] = move.pieceFrom
            board[move.from]?.firstMove = move.first
            board[move.to] = move.pieceTo
            if let piece = board[move.from] {
                if (piece.name == .king && move.to.y - move.from.y > 1){
                    board[move.from.x, 7] = Rook(piece.color == .black ? "br" : "wr")
                    board[move.to.x, move.to.y-1] = nil
                }
                else if (piece.name == .king && move.from.y - move.to.y > 1){
                    board[move.from.x, 0] = Rook(piece.color == .black ? "br" : "wr")
                    board[move.to.x, move.to.y+1] = nil
                }
                
            }
        }
    }
    
    //MARK: move
    //moves a piece to the location, and takes whatever piece that was in that location
    @discardableResult
    func move(from: Position? = nil, to: Position, board: Board?) -> MoveInfo{
        
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
            boardd = self.board
        }
        else {
            boardd = board!
        }
        
        //ok to move, check if any piece is captured
        lastMoves.append(Move(fromm!, to, boardd[fromm!], boardd[to]))
        
        var moveInfo = MoveInfo(ok: true, captured: false)
        if boardd[to] != nil{
            moveInfo.captured = true
        }
        let taken = boardd[fromm!] as Piece?
        boardd[fromm!] = nil
        boardd[to] = taken
        
        //lastMove
        boardd[to]?.firstMove = false
        
        //promote
        if (boardd[to]?.name == .pawn){
            let temp = boardd[to]!
            if (temp.color == .white){
                if ((boardd.flipped == 1 && to.x == 0) || (boardd.flipped == 0 && to.x == 7)) {
                    boardd[to] = Queen("wq")
                }
            }
            else {
                if ((boardd.flipped == 1 && to.x == 7) || (boardd.flipped == 0 && to.x == 0)) {
                    boardd[to] = Queen("bq")
                }
            }
        }
        
        //castle
        if (boardd[fromm!] == nil && boardd[to]?.name == .king && to.y - fromm!.y > 1){
            boardd[to.x, to.y-1] = boardd[fromm!.x, 7]
            boardd[fromm!.x, 7] = nil
        }
        if (boardd[fromm!] == nil && boardd[to]?.name == .king && fromm!.y - to.y > 1){
            boardd[to.x, to.y+1] = boardd[fromm!.x, 0]
            boardd[fromm!.x, 0] = nil
        }
        //castle
        
        //put the board back
//        if (board == nil) {
//            self.board = boardd
//        }
//        else {
//            board = boardd
//        }
        
        
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
        let moveInfo = move(to: to, board: nil)
        
        //if the move is valid
        var res : Move? = nil
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
                
                lastMoves.popLast()
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
        let moveInfo = move(to: to, board: nil)
        let res = moveInfo.ok
        undoMove()
        return res
    }
    
    func makeBotMove() async -> Move?{
        var res: Move? = nil
        switch botDifficulty{
        case.easy:
            res = makeEasyBotMove()
        case.medium:
            res = makeMediumBotMove()
        case.hard:
            await res = makeHardBotMove()
        case.buggy:
            await res = makeBuggyBotMove()
//        default:
//            return makeEasyBotMove()
        }
            
        gameState = checkGameState()
        save()
        resetMoves()
        return res
    }
    
    //MARK: make Bot move
    ///
    ///Function to make an easy bot move
    ///This function retrieves all pieces of its color, iterates through them (shuffled) and makes a random move
    ///After finding a possible move, the functiorn returns.
    func makeEasyBotMove() -> Move?{
        for position in getPlayerPiecePositions().shuffled() {
            chosenPiecePosition = nil
            calcPossiblePositions(from: position)
            let possibleToPossitions = possibleMoves.shuffled()
            if let pickedToPosition = possibleToPossitions.first {
                if (makeMove(to: pickedToPosition) != nil){
                    //if botDiff is acutally buggy, also wreck havoc ;)
                    if (botDifficulty != .buggy) {
                        return makeMove(to: pickedToPosition, sound: true)
                    }
                    else {
                        return wreckHavoc(move: Move(from: position, to: pickedToPosition))
                    }
                }
            }
        }
        return nil
    }
    
    //MARK: make Medium/Buggy Bot move
    ///function to make a medium difficulty bot move
    ///also takes all pieces during that piece's march if difficulty is set to buggy
    func makeMediumBotMove() -> Move?{
        
        //variable to save a move that takes a piece, so we can either do that move or make an easy bot move (random move)
        var possibleMove : Move? = nil
        
        for position in getPlayerPiecePositions().shuffled(){
            //successfully got piece, generating moves
            chosenPiecePosition = nil
            calcPossiblePositions(from: position)
            //shuffle to add randomness
            let possibleToPossitions = possibleMoves.shuffled()
            
            //for each possible position that the piece can move to

            for possibleToPosition in possibleToPossitions{                //checks if the move is possible or not (does not move outside or takes a piece of the same color)
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
                            chosenPiecePosition = position
                            return makeMove(to: possibleToPosition, sound: true)
                        } else {
                            return wreckHavoc(move: Move(from: position, to: possibleToPosition))
                        }
                    }
                }
            }
        }
                                
        if let move = possibleMove{
            //use this move instead
            if (botDifficulty == .medium) {
                chosenPiecePosition = move.from
                return makeMove(to: move.to, sound: true)
            } else {
                return wreckHavoc(move: Move(from: move.from, to: move.to))
            }
//            chosenPiecePosition = move.from
//            return makeMove(to: move.to, sound: true)
        }
        return makeEasyBotMove()
    }
    
    //MARK: STUPID GOOD AI COPIED FROM INTERNET???!?!!!
    func makeHardBotMove() async -> Move?{
        let ai = await AILogic()
        if let move = await ai.getBestMove(stage: self, depth: 2) {
            chosenPiecePosition = move.from
            return makeMove(to: move.to, sound: true)
        } else{
            return nil
        }
    }
    
    //MARK: STUPID GOOD AI COPIED FROM INTERNET???!?!!!
    func makeBuggyBotMove() async -> Move?{
        let ai = await AILogic()
        if let move = await ai.getBestMove(stage: self, depth: 2) {
            chosenPiecePosition = move.from
            return wreckHavoc(move: move)
        } else{
            return nil
        }
    }
    
    //MARK: WRECK HAVOC
    ///This function does exactly what is says
    ///be careful
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
            resetMoves()
            moved.toggle()
        }
        else{
            showMoves = calcPossiblePositions(from: at)
        }
    }
    
    //reset chosenPiecePosition and possibleMoves so players can cancel chossing a piece
    func resetMoves(){
        chosenPiecePosition = nil
        possibleMoves = []
        showMoves = []
    }
}
