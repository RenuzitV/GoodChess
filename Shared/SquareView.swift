//
//  SquareView.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

struct SquareView: View {
    var size : Double
    var color : Color
    var body: some View {
        ZStack{
            Rectangle()
                .fill(color)
                .frame(width: size, height: size)
        }
    }
}

struct SquareView_Previews: PreviewProvider {
    static var previews: some View {
        SquareView(size: 200, color: .brown)
    }
}
