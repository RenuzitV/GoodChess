//
//  HowToPlayView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 26/08/2022.
//https://www.chess.com/learn-how-to-play-chess

import SwiftUI

struct HowToPlayView: View {
    
    var body: some View {
        ScrollView{
            //lazy so it doesnt lag as much
            LazyVStack(alignment: .leading, spacing: 15){
                Group{
                    Text("Tutorial\n")
                        .font(.largeTitle).bold() +
                    Text("Step 1. How To Setup The Chessboard\n")
                        .font(.title2).bold() +
                    Text("At the beginning of the game the chessboard is laid out so that each player has the white (or light) color square in the bottom right-hand side.")
                    
                    StaticBoardView(board: Board(true))
                    
                    Text("The chess pieces are then arranged the same way each time. The second row (or rank) is filled with pawns. The rooks go in the corners, then the knights next to them, followed by the bishops, and finally the queen, who always goes on her own matching color (white queen on white, black queen on black), and the king on the remaining square.")
                    
                    StaticBoardView(board: Board())
                    
                    Text("Step 2. How The Chess Pieces Move\n")
                        .font(.title2).bold() +
                    Text("Each of the 6 different kinds of pieces moves differently. Pieces cannot move through other pieces (though the knight can jump over other pieces), and can never move onto a square with one of their own pieces. However, they can be moved to take the place of an opponent's piece which is then captured. Pieces are generally moved into positions where they can capture other pieces (by landing on their square and then replacing them), defend their own pieces in case of capture, or control important squares in the game.")
                    
                    Text("How To Move The Queen In Chess\n")
                        .font(.title2).bold() +
                    Text("The queen is the most powerful piece. She can move in any one straight direction - forward, backward, sideways, or diagonally - as far as possible as long as she does not move through any of her own pieces.")
                    
                    boardViewWithQueenMoves
                    
                    Text("How To Move The Rook In Chess\n")
                        .font(.title2).bold() +
                    Text("The rook may move as far as it wants, but only forward, backward, and to the sides.")
                    
                    boardViewWithRookMoves
                }
                
                Group{
                    Text("How To Move The Bishop In Chess\n")
                        .font(.title2).bold() +
                    Text("The bishop may move as far as it wants, but only diagonally. Each bishop starts on one color (light or dark) and must always stay on that color.")
                    
                    boardViewWithBishopMoves
                    
                    Text("How To Move The Knight In Chess\n")
                        .font(.title2).bold() +
                    Text("Knights move in a very different way from the other pieces – going two squares in one direction, and then one more move at a 90-degree angle, just like the shape of an “L”.\nKnights are also the only pieces that can move over other pieces.")
                    
                    boardViewWithKnightMoves
                    
                    Text("How To Move The Pawn In Chess\n")
                        .font(.title2).bold() +
                    Text("Pawns are unusual because they move and capture in different ways: they move forward but capture diagonally. Pawns can only move forward one square at a time, except for their very first move where they can move forward two squares.\nPawns can only capture one square diagonally in front of them. They can never move or capture backward. If there is another piece directly in front of a pawn he cannot move past or capture that piece.")
                    
                    boardViewWithPawnMoves
                    
                    Text("How To Move The King In Chess\n")
                        .font(.title2).bold() +
                    Text("The king is the most important piece, but is one of the weakest. The king can only move one square in any direction - up, down, to the sides, and diagonally.The king may never move himself into check (where he could be captured). When the king is attacked by another piece this is called \"check\".")
                    
                    boardViewWithKingMoves
                }
                
                Group{
                    Text("When your king is checked, you must make a move that releases the king from check, either by blocking an enemy piece's move or by moving the king out of the way. A checkmate happens when you cannot make any move out of check. This is how you win (or lose)!")
                    
                    boardViewWithCheckmatedKing
                    
                    Text("Step 3. Discover The Special Rules Of Chess")
                        .font(.title2).bold()
                    
                    Text("How To Promote A Pawn In Chess\n")
                        .font(.title2).bold() +
                    Text("Pawns have another special ability and that is that if a pawn reaches the other side of the board it can become any other chess piece (called promotion) excluding a king (or pawn, for that matter).")
                    
                    HStack{
                        boardViewWithPawnAlmostPromote
                        boardViewWithPromotedPawn
                    }
                                        
                    Text("A pawn is usually promoted to a queen. Only pawns may be promoted. However, in this game, a pawn is automatically promoted to a Queen.")
                    
                    Text("How To Castle In Chess\n")
                        .font(.title2).bold() +
                    Text("One other special chess rule is called castling. This move allows you to do two important things all in one move: get your king to safety (hopefully), and get your rook out of the corner and into the game. On a player's turn he may move his king two squares over to one side and then move the rook from that side's corner to right next to the king on the opposite side. (See the example below.) However, in order to castle, the following conditions must be met:\n\tit must be that king's very first move\n\tit must be that rook's very first move\n\tthere cannot be any pieces between the king and rook to move\n\tthe king may not be in check or pass through check")
                    
                    boardViewWithKingAlmostCastle
                    
                    Text("Notice that when you castle one direction the king is closer to the side of the board. That is called castling \"kingside\". Castling to the other side, through where the queen sat, is called castling \"queenside\". Regardless of which side, the king always moves only two squares when castling.")
                    
                }
                
                Group{
                    HStack{
                        boardViewWithQueenSideCastle
                        boardViewWithKingSideCastle
                    }
                    
                    Text("Now that you've known the basics, you can go out there and try to win some games in singleplayer or with a friend!")
                }
            }
        }
        .font(.title3)
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
