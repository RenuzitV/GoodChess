//
//  PieceView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct PieceView: View {
    var piece : Optional<Piece>
    var body: some View {
        Image(piece == nil ? "" : piece!.path)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView(piece: Piece.example)
    }
}
