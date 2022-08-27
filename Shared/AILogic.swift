//
//  AILogic.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 25/08/2022.
//https://www.freecodecamp.org/news/simple-chess-ai-step-by-step-1d55a9266977/

import Foundation

var count = 0
var first = true

@MainActor
struct AILogic{
    func minimaxRoot(stage : Stage, depth : Int, isMaximisingPlayer: Bool) -> Move? {
        let newGameMoves = stage.calcPossibleMoves()
        var bestMove = -Double.greatestFiniteMagnitude
        var bestMoveFound : Move? = nil
        count = 0
        for newGameMove in newGameMoves {
            stage.chosenPiecePosition = newGameMove.from
            stage.move(to: newGameMove.to, board: nil)
            stage.board.turn = stage.board.turn == .white ? .black : .white
            let value = minimax(depth: depth - 1, stage: stage, alpha: -Double.greatestFiniteMagnitude, beta: Double.greatestFiniteMagnitude, isMaximisingPlayer: !isMaximisingPlayer)
            stage.undoMove()
            stage.board.turn = stage.board.turn == .white ? .black : .white
            
            if (value >= bestMove) {
                bestMove = value
                bestMoveFound = newGameMove
            }
        }
        print("positions: \(count)")
        print("score: \(bestMove)")
//        print(evaluateBoard(stage.board, debug: true))
        return bestMoveFound
    }
    
    func minimax(depth: Int, stage: Stage, alpha: Double, beta: Double, isMaximisingPlayer: Bool) -> Double{
        count += 1
        if (depth == 0) {
            return -evaluateBoard(stage.board)
        }
        
        let newGameMoves = stage.calcPossibleMoves()
//        print(newGameMoves.count)
        var mutableAlpha = alpha
        var mutableBeta = beta
        
        if (isMaximisingPlayer) {
            var bestMove = -Double.greatestFiniteMagnitude
            for newGameMove in newGameMoves {
                stage.chosenPiecePosition = newGameMove.from
                stage.move(to: newGameMove.to, board: nil)
                stage.board.turn = stage.board.turn == .white ? .black : .white
                bestMove = max(bestMove, minimax(depth: depth - 1, stage: stage, alpha: mutableAlpha, beta: mutableBeta, isMaximisingPlayer: !isMaximisingPlayer))
                stage.undoMove()
                stage.board.turn = stage.board.turn == .white ? .black : .white
                
                mutableAlpha = max(mutableAlpha, bestMove)
                
                if (mutableBeta <= mutableAlpha) {
                    return bestMove
                }
                
            }
            
            return bestMove
        } else {
            var bestMove = Double.greatestFiniteMagnitude
            
            for newGameMove in newGameMoves {
                stage.chosenPiecePosition = newGameMove.from
                stage.move(to: newGameMove.to, board: nil)
                stage.board.turn = stage.board.turn == .white ? .black : .white
                bestMove = min(bestMove, minimax(depth: depth - 1, stage: stage, alpha: mutableAlpha, beta: mutableBeta, isMaximisingPlayer: !isMaximisingPlayer))
                stage.undoMove()
                stage.board.turn = stage.board.turn == .white ? .black : .white
                
                mutableBeta = min(mutableBeta, bestMove)
                
                if (mutableBeta <= mutableAlpha) {
                    return bestMove
                }
                
            }
            
            return bestMove
        }
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
            [-5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0]
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
            [-3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
            [-3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
            [-3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
            [-3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
            [-2.0, -3.0, -3.0, -4.0, -4.0, -3.0, -3.0, -2.0],
            [-1.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -1.0],
            [2.0, 2.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0],
            [2.0, 3.0, 1.0, 0.0, 0.0, 1.0, 3.0, 2.0]
        ]
        
        pawnEvalBlack = reverseArray(pawnEvalWhite)
        kingEvalBlack = reverseArray(kingEvalWhite)
        rookEvalBlack = reverseArray(rookEvalWhite)
        bishopEvalBlack = reverseArray(bishopEvalWhite)
    }
    
    var pieceImportanceMultiplier = 1.0
    
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
            return 900 * pieceImportanceMultiplier + (piece.color == .white ? kingEvalWhite[x][y] : kingEvalBlack[x][y])
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
    func getBestMove(stage: Stage, depth: Int) async -> Move? {
        let res = Task.detached(operation: {
            await minimaxRoot(stage: stage, depth: depth, isMaximisingPlayer: true)
        }) as Task<Move?, Never>
        return await res.value
    }
    
}

func reverseArray(_ array: [[Double]]) -> [[Double]] {
    return array.reversed()
}
