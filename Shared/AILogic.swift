//
//  AILogic.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 25/08/2022.
//https://www.freecodecamp.org/news/simple-chess-ai-step-by-step-1d55a9266977/

import Foundation

struct AILogic{
    
    func minimaxRoot(stage : Stage, depth : Int, isMaximisingPlayer: Bool) -> Move {
        let newGameMoves = stage.calcPossibleMoves()
        var bestMove = -9999.0
        var bestMoveFound : Move = Move(from: Position(), to: Position())
        
        for newGameMove in newGameMoves {
            var nilBoard: Board? = nil
            stage.chosenPiecePosition = newGameMove.from
            stage.move(to: newGameMove.to, board: &nilBoard)
            let value = minimax(depth: depth - 1, stage: stage, alpha: -10000, beta: 10000, isMaximisingPlayer: !isMaximisingPlayer)
            stage.undoMove()
            
            if (value >= bestMove) {
                bestMove = value
                bestMoveFound = newGameMove
            }
        }
        return bestMoveFound
    }
    
    func minimax(depth: Int, stage: Stage, alpha: Double, beta: Double, isMaximisingPlayer: Bool) -> Double{
        if (depth == 0) {
            return -evaluateBoard(stage.board)
        }
        
        let newGameMoves = stage.calcPossibleMoves()
        var mutableAlpha = alpha
        var mutableBeta = beta
        
        if (isMaximisingPlayer) {
            var bestMove = -9999.0
            for newGameMove in newGameMoves {
                var nilBoard: Board? = nil
                stage.chosenPiecePosition = newGameMove.from
                stage.move(to: newGameMove.to, board: &nilBoard)
                bestMove = max(bestMove, minimax(depth: depth - 1, stage: stage, alpha: mutableAlpha, beta: mutableBeta, isMaximisingPlayer: !isMaximisingPlayer))
                stage.undoMove()
                
                mutableAlpha = max(mutableAlpha, bestMove)
                
                if (mutableBeta <= mutableAlpha) {
                    return bestMove
                }
                
            }
            
            return bestMove
        } else {
            var bestMove = 9999.0
            
            for newGameMove in newGameMoves {
                var nilBoard: Board? = nil
                stage.chosenPiecePosition = newGameMove.from
                stage.move(to: newGameMove.to, board: &nilBoard)
                bestMove = max(bestMove, minimax(depth: depth - 1, stage: stage, alpha: mutableAlpha, beta: mutableBeta, isMaximisingPlayer: !isMaximisingPlayer))
                stage.undoMove()
                
                mutableBeta = max(mutableBeta, bestMove)
                
                if (mutableBeta <= mutableAlpha) {
                    return bestMove
                }
                
            }
            
            return bestMove
        }
    }
    
    
    
    func evaluateBoard(_ board: Board) -> Double {
        var totalEvaluation = 0.0
        for i in 0..<8 {
            for j in 0..<8 {
                totalEvaluation = totalEvaluation + getPieceValue(board[i, j], i, j)
            }
        }
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
        pawnEvalWhite = [
            [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
            [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0],
            [1.0, 1.0, 2.0, 3.0, 3.0, 2.0, 1.0, 1.0],
            [0.5, 0.5, 1.0, 2.5, 2.5, 1.0, 0.5, 0.5],
            [0.0, 0.0, 0.0, 2.0, 2.0, 0.0, 0.0, 0.0],
            [0.5, -0.5, -1.0, 0.0, 0.0, -1.0, -0.5, 0.5],
            [0.5, 1.0, 1.0, -2.0, -2.0, 1.0, 1.0, 0.5],
            [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        ]
        
        knightEval = [
            [-5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0],
            [-4.0, -2.0, 0.0, 0.0, 0.0, 0.0, -2.0, -4.0],
            [-3.0, 0.0, 1.0, 1.5, 1.5, 1.0, 0.0, -3.0],
            [-3.0, 0.5, 1.5, 2.0, 2.0, 1.5, 0.5, -3.0],
            [-3.0, 0.0, 1.5, 2.0, 2.0, 1.5, 0.0, -3.0],
            [-3.0, 0.5, 1.0, 1.5, 1.5, 1.0, 0.5, -3.0],
            [-4.0, -2.0, 0.0, 0.5, 0.5, 0.0, -2.0, -4.0],
            [-5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0]
        ]
        bishopEvalWhite = [
            [-2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0],
            [-1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0],
            [-1.0, 0.0, 0.5, 1.0, 1.0, 0.5, 0.0, -1.0],
            [-1.0, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, -1.0],
            [-1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, -1.0],
            [-1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, -1.0],
            [-1.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.5, -1.0],
            [-2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0]
        ]
        
        rookEvalWhite = [
            [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
            [0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5],
            [0.0, 0.0, 0.0, 0.5, 0.5, 0.0, 0.0, 0.0]
        ]
        
        evalQueen = [
            [-2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0],
            [-1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0],
            [-1.0, 0.0, 0.5, 0.5, 0.5, 0.5, 0.0, -1.0],
            [-0.5, 0.0, 0.5, 0.5, 0.5, 0.5, 0.0, -0.5],
            [0.0, 0.0, 0.5, 0.5, 0.5, 0.5, 0.0, -0.5],
            [-1.0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.0, -1.0],
            [-1.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, -1.0],
            [-2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0]
        ]
        
        kingEvalWhite = [
            [-3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
            [-3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
            [-3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
            [-3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
            [-2.0, -3.0, -3.0, -4.0, -4.0, -3.0, -3.0, -2.0],
            [-1.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -1.0],
            [2.0, 2.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0],
            [2.0, 3.0, 1.0, 0.0, 0.0, 1.0, 3.0, 2.0]
        ]
        
        kingEvalBlack = reverseArray(kingEvalWhite)
        rookEvalBlack = reverseArray(rookEvalWhite)
        bishopEvalBlack = reverseArray(bishopEvalWhite)
        pawnEvalBlack = reverseArray(bishopEvalWhite)
    }
    
    func getAbsoluteValue(_ piece: Piece, _ x: Int, _ y: Int) -> Double{
        if (piece.name == .pawn) {
            return 10 + (piece.color == .white ? pawnEvalWhite[x][y] : pawnEvalBlack[x][y])
        } else if (piece.name == .rook) {
            return 50 + (piece.color == .white ? rookEvalWhite[x][y] : rookEvalBlack[x][y])
        } else if (piece.name == .knight) {
            return 30 + knightEval[x][y]
        } else if (piece.name == .bishop) {
            return 30 + (piece.color == .white ? bishopEvalWhite[x][y] : bishopEvalBlack[x][y])
        } else if (piece.name == .queen) {
            return 90 + evalQueen[x][y]
        } else if (piece.name == .king) {
            return 900 + (piece.color == .white ? kingEvalWhite[x][y] : kingEvalBlack[x][y])
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
    func getBestMove(stage: Stage, depth: Int) -> Move {
        return minimaxRoot(stage: stage, depth: depth, isMaximisingPlayer: true)
    }
    
}

func reverseArray(_ array: [[Double]]) -> [[Double]] {
    var eval = array
    for i in 0..<8 {
        for j in 0..<8 {
            let temp = eval[i][j]
            eval[i][j] = eval[7 - i][7 - j]
            eval[7 - i][7 - j] = temp
        }
    }
    return eval
}
