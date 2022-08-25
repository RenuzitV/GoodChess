//
//  ButtonView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//

import SwiftUI

struct ButtonView: View {
    var body: some View {
        Text("Hello, World!")
            .font(.title)
    }
}

struct RoundRect: View{
    var size: CGFloat = 0.5
    var background: Color = Color.accentColor.opacity(0.1)
    
    init(_ size: CGFloat = 0.5, _ background: Color = Color.accentColor.opacity(0.1)){
        self.size = size
        self.background = background
    }
    
    var body: some View{
        Text(" ")
            .customButton(size, background)
    }
}

extension View {
    func customButton(_ w: CGFloat = 0.5, _ color : Color = Color.accentColor.opacity(0.1), _ foreground : Color = Color.accentColor, font : Font = .title) -> some View {
        return self
            .padding(10)
            .frame(width: vw(w))
            .background(color)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(foreground, lineWidth: 2)
                    .opacity(0.7)
            )
            .buttonStyle(.plain)
            .font(font)
            .foregroundColor(foreground)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ButtonView()
                .customButton(0.5)
            RoundRect()
        }
    }
}
