//
//  PlayView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//https://stackoverflow.com/questions/61424225/macos-swiftui-navigation-for-a-single-view

import Foundation
import SwiftUI

struct PlayView: View {
    @EnvironmentObject var stage: Stage
    
    @Binding var currentSubviewIndex: Int
    @Binding var currentSubviewDepth: Int
    
    var body: some View {
        VStack{
            Spacer()
            
            //singleplayer
            Button(action: {
                self.showSubview(withIndex: 4, withDepth: 2)
                stage.versusBot = true
            }) {
                Label("Play with Bot", systemImage: "person")
            }
            .customButton(0.7)
            
            Spacer()
            
            //multiplayer
            Button(action: {
                self.showSubview(withIndex: 4, withDepth: 2)
                stage.versusBot = false
            }) {
                Label("Play with Friend", systemImage: "person.2")
            }
            .customButton(0.7)
            
            Spacer()
        }
        .foregroundColor(.accentColor)
        .font(.title)
    }
    
    private func showSubview(withIndex index: Int, withDepth depth: Int) {
        currentSubviewIndex = index
        currentSubviewDepth = depth
    }
}
