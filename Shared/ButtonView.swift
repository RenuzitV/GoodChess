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
    }
}

struct RoundRect: View {
    var w: CGFloat = 0.5
    var color: Color = Color.accentColor
    var background: Color = Color.accentColor.opacity(0.1)
    
    init(_ w: CGFloat = 0.5){
        self.w = w
    }
    var body: some View {
        Text(" ")
            .padding(10)
            .frame(width: vw(w))
            .background(background)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(color, lineWidth: 2)
                    .opacity(0.7)
            )
            .buttonStyle(.plain)
            .font(.title)
            .foregroundColor(color)
    }
}

extension View {
    func customButton(_ w: CGFloat = 0.5, _ color : Color = Color.accentColor, _ background: Color = Color.accentColor.opacity(0.1)) -> some View {
        return self
            .padding(10)
            .frame(width: vw(w))
            .background(background)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(color, lineWidth: 2)
                    .opacity(0.7)
            )
            .buttonStyle(.plain)
            .font(.title)
            .foregroundColor(color)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
            .customButton(0.5)
    }
}
