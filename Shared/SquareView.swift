//
//  SquareView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct SquareView: View {
    var square : Square
    var size : Double
    var body: some View {
        ZStack{
            Rectangle()
                .fill(square.color)
                .frame(width: size, height: size)
            PieceView(piece: square.piece)
                .frame(width: size, height: size)
        }
    }
}

struct SquareView_Previews: PreviewProvider {
    static var previews: some View {
        SquareView(square: Square(color: .brown), size: 200)
        SquareView(square: Square(color: .brown, piece: Piece.example), size: 200)
    }
}
