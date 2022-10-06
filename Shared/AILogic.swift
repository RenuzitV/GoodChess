//
//  AILogic.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 25/08/2022.
//https://www.freecodecamp.org/news/simple-chess-ai-step-by-step-1d55a9266977/

import Foundation

var count = 0
var first = true

struct MoveWithScore{
    var move: Move
    var score: Double
}

var scores : [Int:Double] = [:]

struct AILogic{
    
    func minimaxRoot(stage : Stage, depth : Int, isMaximisingPlayer: Bool) -> Move? {
        //check if it is still playable i.e there is a move to continue the game
        if (stage.checkGameState() != .playing) {
            return nil
        }
        
        let startTime = Date.now
        
        let newGameMoves = stage.calcPossibleMoves()
        
        //generate extra depth if there is less pieces on the board
        var numOfPieces: Int = stage.getPlayerPiecePositions().count
        stage.board.turn = stage.board.turn == .white ? .black : .white
        numOfPieces += stage.getPlayerPiecePositions().count
        stage.board.turn = stage.board.turn == .white ? .black : .white
        let extraDepth: Int
        if (numOfPieces > 5){  
            extraDepth = 0
        } else {
            extraDepth = 1
        }
        
        //save best move and best moves found, so we can randomize the best move within a certain margins
        var bestMove = -Double.greatestFiniteMagnitude
        var bestMovesFound : [MoveWithScore] = []
        count = 0
        //make the move and dfs further to check for scoring
        for newGameMove in newGameMoves {
            stage.chosenPiecePosition = newGameMove.from
            stage.move(to: newGameMove.to, board: nil)
            stage.board.turn = stage.board.turn == .white ? .black : .white
            let value = minimax(depth: depth - 1 + extraDepth, stage: stage, alpha: -Double.greatestFiniteMagnitude, beta: Double.greatestFiniteMagnitude, isMaximisingPlayer: !isMaximisingPlayer)
            stage.undoMove()
            stage.board.turn = stage.board.turn == .white ? .black : .white
            
            bestMovesFound.append(MoveWithScore(move: newGameMove, score: value))
            if (value >= bestMove) {
                bestMove = value
            }
        }
        print("different positions: \(count)")
        print("score: \(bestMove)")
        print("time to calc: \(-startTime.timeIntervalSinceNow)")
//        print(evaluateBoard(stage.board, debug: true))
        //get any move that has a score within the 90 percentile score of the best move, but not less than 10 points to prevent saccing a pawn or more. since forced moves makes everything else have negative infinity score, they will be the only moves that does not get filtered
        return bestMovesFound.filter({ $0.score >= bestMove - 9 }).shuffled().first?.move
    }
    
    //same as above, just not the root.
    func minimax(depth: Int, stage: Stage, alpha: Double, beta: Double, isMaximisingPlayer: Bool) -> Double{
        count += 1
//        if let score = scores[stage.board.hashValue]{
//            return score
//        }
        if (depth == 0) {
            let score = -evaluateBoard(stage.board)
//            scores[stage.board.hashValue] = score
            return score
        }
        
        //calculate all moves, including moves that will lose the game (invalid board state)
        let newGameMoves = stage.calcPossibleMoves(ugly: true)
//        print(newGameMoves.count)
        var mutableAlpha = alpha
        var mutableBeta = beta
        var bestMove = 0.0
        
        if (isMaximisingPlayer) {
            bestMove = -Double.greatestFiniteMagnitude
            
            for newGameMove in newGameMoves {
                stage.chosenPiecePosition = newGameMove.from
                stage.move(to: newGameMove.to, board: nil)
                stage.board.turn = stage.board.turn == .white ? .black : .white
                bestMove = max(bestMove, minimax(depth: depth - 1, stage: stage, alpha: mutableAlpha, beta: mutableBeta, isMaximisingPlayer: !isMaximisingPlayer))
                stage.undoMove()
                stage.board.turn = stage.board.turn == .white ? .black : .white
                
                mutableAlpha = max(mutableAlpha, bestMove)
                
                if (mutableBeta <= mutableAlpha) {
                    break
                }
            }
        } else {
            bestMove = Double.greatestFiniteMagnitude
            
            for newGameMove in newGameMoves {
                stage.chosenPiecePosition = newGameMove.from
                stage.move(to: newGameMove.to, board: nil)
                stage.board.turn = stage.board.turn == .white ? .black : .white
                bestMove = min(bestMove, minimax(depth: depth - 1, stage: stage, alpha: mutableAlpha, beta: mutableBeta, isMaximisingPlayer: !isMaximisingPlayer))
                stage.undoMove()
                stage.board.turn = stage.board.turn == .white ? .black : .white
                
                mutableBeta = min(mutableBeta, bestMove)
                
                if (mutableBeta <= mutableAlpha) {
                    break
                }
                
            }
            
        }
        
        return bestMove
    }
    
    
    
    func evaluateBoard(_ board: Board, debug: Bool = false) -> Double {
        var totalEvaluation = 0.0
        for i in 0..<8 {
            for j in 0..<8 {
                if (debug) {
                    print(getPieceValue(board[i, j], i, j))
                }
                totalEvaluation = totalEvaluation + getPieceValue(board[i, j], i, j)
            }
        }
        first = false
//        print(totalEvaluation)
        return totalEvaluation
    }
    
    var pawnEvalWhite: [[Double]]
    
    var pawnEvalBlack: [[Double]]
    
    var knightEval : [[Double]]
    
    var bishopEvalWhite : [[Double]]
    
    var bishopEvalBlack: [[Double]]
    
    var rookEvalWhite: [[Double]]
    
    var rookEvalBlack: [[Double]]
    
    var evalQueen: [[Double]]
    
    var kingEvalWhite: [[Double]]
    
    var kingEvalBlack: [[Double]]
    
    //init piece position value, used to evaluate how good a piece is at a certain position
    init(){
        pawnEvalWhite =
        [
            [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
            [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0],
            [1.0, 1.0, 2.0, 3.0, 3.0, 2.0, 1.0, 1.0],
            [0.5, 0.5, 1.0, 2.5, 2.5, 1.0, 0.5, 0.5],
            [0.0, 0.0, 0.0, 2.0, 2.0, 0.0, 0.0, 0.0],
            [0.5, -0.5, -1.0, 0.0, 0.0, -1.0, -0.5, 0.5],
            [0.5, 1.0, 1.0, -2.0, -2.0, 1.0, 1.0, 0.5],
            [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        ]
        
        knightEval =
        [
            [-5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0],
            [-4.0, -2.0, 0.0, 0.0, 0.0, 0.0, -2.0, -4.0],
            [-3.0, 0.0, 1.0, 1.5, 1.5, 1.0, 0.0, -3.0],
            [-3.0, 0.5, 1.5, 2.0, 2.0, 1.5, 0.5, -3.0],
            [-3.0, 0.0, 1.5, 2.0, 2.0, 1.5, 0.0, -3.0],
            [-3.0, 0.5, 1.0, 1.5, 1.5, 1.0, 0.5, -3.0],
            [-4.0, -2.0, 0.0, 0.5, 0.5, 0.0, -2.0, -4.0],
            [-5.0, -2.5, -3.0, -3.0, -3.0, -3.0, -2.5, -5.0]
        ]
        bishopEvalWhite =
        [
            [-2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0],
            [-1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0],
            [-1.0, 0.0, 0.5, 1.0, 1.0, 0.5, 0.0, -1.0],
            [-1.0, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, -1.0],
            [-1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, -1.0],
            [-1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, -1.0],
            [-1.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.5, -1.0],
            [-2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0]
        ]
        
        rookEvalWhite =
        [
            [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
            [0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [0.0, 0.0, 0.0, 0.5, 0.5, 0.0, 0.0, 0.0]
        ]
        
        evalQueen =
        [
            [-2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0],
            [-1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0],
            [-1.0, 0.0, 0.5, 0.5, 0.5, 0.5, 0.0, -1.0],
            [-0.5, 0.0, 0.5, 0.5, 0.5, 0.5, 0.0, -0.5],
            [0.0, 0.0, 0.5, 0.5, 0.5, 0.5, 0.0, -0.5],
            [-1.0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.0, -1.0],
            [-1.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, -1.0],
            [-2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0]
        ]
        
        kingEvalWhite =
        [
            [-3.0, -3.0, -3.0, -3.0, -3.0, -3.0, -3.0, -3.0],
            [-3.0, -3.0, -3.0, -3.0, -3.0, -3.0, -3.0, -3.0],
            [-3.0, -3.0, -3.0, -3.0, -3.0, -3.0, -3.0, -3.0],
            [-3.0, -3.0, -3.0, -3.0, -3.0, -3.0, -3.0, -3.0],
            [-1.5, -2.5, -2.5, -3.0, -3.0, -2.5, -2.5, -1.0],
            [-1.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -1.0],
            [2.0, 2.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0],
            [2.0, 3.0, 5.0, 0.0, 0.0, 1.0, 5.0, 2.0]
        ]
        
        pawnEvalBlack = reverseArray(pawnEvalWhite)
        kingEvalBlack = reverseArray(kingEvalWhite)
        rookEvalBlack = reverseArray(rookEvalWhite)
        bishopEvalBlack = reverseArray(bishopEvalWhite)
    }
    
    var pieceImportanceMultiplier = 1.0
    
    //get the value of a certain piece at a certain position
    func getAbsoluteValue(_ piece: Piece, _ x: Int, _ y: Int) -> Double{
        if (piece.name == .pawn) {
            return 10 * pieceImportanceMultiplier + (piece.color == .white ? pawnEvalWhite[x][y] : pawnEvalBlack[x][y])
        } else if (piece.name == .rook) {
            return 50 * pieceImportanceMultiplier + (piece.color == .white ? rookEvalWhite[x][y] : rookEvalBlack[x][y])
        } else if (piece.name == .knight) {
            return 30 * pieceImportanceMultiplier + knightEval[x][y]
        } else if (piece.name == .bishop) {
            return 30 * pieceImportanceMultiplier + (piece.color == .white ? bishopEvalWhite[x][y] : bishopEvalBlack[x][y])
        } else if (piece.name == .queen) {
            return 90 * pieceImportanceMultiplier + evalQueen[x][y]
        } else if (piece.name == .king) {
            return 90000 * pieceImportanceMultiplier + (piece.color == .white ? kingEvalWhite[x][y] : kingEvalBlack[x][y])
        } else{
            print("piece not known")
        }
        return 0
    }
    
    func getPieceValue(_ piece: Piece?, _ x: Int, _ y: Int) -> Double {
        if (piece === nil) {
            return 0
        }
        let absoluteValue = getAbsoluteValue(piece!, x, y)
        return piece?.color == .white ? absoluteValue : -absoluteValue
    }
    
    //call this to get best move
    func getBestMove(stage: Stage, depth: Int = 3) -> Move? {
        print("current board hash: \(stage.board.hashValue)")
        return self.minimaxRoot(stage: Stage(stage: stage), depth: depth, isMaximisingPlayer: true)
    }
    
}

func reverseArray(_ array: [[Double]]) -> [[Double]] {
    return array.reversed()
}
