//
//  ButtonView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//

import SwiftUI

struct ButtonView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .foregroundColor(.accentColor)
            .font(.title)
    }
}

extension View {
    func customButton(_ w: CGFloat = 0.5, _ color : Color = Color.accentColor) -> some View {
        return self
            .padding(10)
            .frame(width: vw(w))
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.accentColor, lineWidth: 2)
                    .opacity(0.7)
            )
            .buttonStyle(.plain)
            .foregroundColor(color)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
            .customButton(0.5)
    }
}
