//
//  ContentView.swift
//  Shared
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//https://stackoverflow.com/questions/61424225/macos-swiftui-navigation-for-a-single-view

import SwiftUI

struct ContentView: View {
    @StateObject var stage: Stage = Stage()
    @StateObject var gameHistory: GameHistory = GameHistory()
    @StateObject var gameSetting: GameSetting = GameSetting()
    
    @State private var currentSubviewIndex = 0
    @State private var currentSubviewDepth = 0
    
    var body: some View {
        StackNavigationView(
            currentSubviewIndex: self.$currentSubviewIndex,
            currentSubviewDepth: self.$currentSubviewDepth,
            viewByIndex: { index in
                self.subView(forIndex: index)
            },
            numofIndexes: 6
        )
        .background(backgroundColor)
        .foregroundColor(.accentColor)
        .font(.title)
    }
    
    var mainView: some View{
        VStack(){
            Spacer()
            
            Button(action: { self.showSubview(withIndex: 1, withDepth: 1) }) {
                Label("Play", systemImage: "play.fill")
            }
            .customButton()
            
            Spacer()
            
            Button(action: { self.showSubview(withIndex: 2, withDepth: 1) }) {
                Label("Settings", systemImage: "slider.vertical.3")
            }
            .customButton()
            
            Spacer()
            
            Button(action: { self.showSubview(withIndex: 3, withDepth: 1) }) {
                Label("History", systemImage: "book.closed.fill")
            }
            .customButton()
            
            Spacer()
            
            Button(action: { self.showSubview(withIndex: 5, withDepth: 1) }) {
                Label("Tutorial", systemImage: "book.closed")
            }
            .customButton()
            
            Spacer()
        }
    }
    
    private func showSubview(withIndex index: Int, withDepth depth: Int) {
        currentSubviewDepth = depth
        currentSubviewIndex = index
    }
    
    private func subView(forIndex index: Int) -> AnyView {
        switch index {
        case 0: return AnyView(mainView)
        case 1: return AnyView(
            PlayView(stage: stage, gameSetting: gameSetting, currentSubviewIndex: $currentSubviewIndex, currentSubviewDepth: $currentSubviewDepth))
        case 2: return AnyView(SettingsView(gameSetting: gameSetting))
        case 3: return AnyView(HistoryView(history: gameHistory, gameSetting: gameSetting))
        case 4: return AnyView(StageView(stage: stage, gameSetting: gameSetting, gameHistory: gameHistory, currentSubviewIndex: $currentSubviewIndex, currentSubviewDepth: $currentSubviewDepth))
        case 5: return AnyView(HowToPlayView())
        default: return AnyView(Text("Inavlid Selection").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
