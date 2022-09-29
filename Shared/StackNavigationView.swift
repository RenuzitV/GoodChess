//
//  StackNavigationView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//https://stackoverflow.com/questions/61424225/macos-swiftui-navigation-for-a-single-view

import SwiftUI

struct StackNavigationView<SubviewContent>: View where SubviewContent: View {
    
    @Binding var currentSubviewIndex: Int
    @Binding var currentSubviewDepth: Int
    
    let viewByIndex: (Int) -> SubviewContent
    
    let numOfIndexes: Int
    
    @State var previousSubviewDepth: Int = 0
    @State var lastToMove: Bool = true
    @State var viewDidLoad: Bool = false
    
    let trail = AnyTransition.move(edge: .trailing)
    let lead = AnyTransition.move(edge: .leading)
    
    let animationDuration = 0.35
    
    var body: some View {
        VStack {
            VStack{
                ForEach(0..<numOfIndexes, id: \.self){ currentIndex in
                    if (currentIndex == currentSubviewIndex){
                        StackNavigationSubview(currentIndex: self.$currentSubviewIndex, currentDepth: self.$currentSubviewDepth, lastToMove: $lastToMove) {
                            self.viewByIndex(self.currentSubviewIndex)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        //better but broken, if fix then nice
//                        .transition(previousSubviewDepth < currentSubviewDepth ? (lastToMove ? lead : trail) : (lastToMove ? lead : trail))
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            )
                        )
                        //only allow interaction after view has finished animating
                        .allowsHitTesting(viewDidLoad)
                        .onAppear(){
                            if (lastToMove){
                                previousSubviewDepth = currentSubviewDepth
                            }
                            lastToMove = true
                            viewDidLoad = false
                            DispatchQueue.background(delay: animationDuration, completion: {
                                viewDidLoad = true
                            })
                        }
                    }
                }
            }
        }
        .animation(.easeOut(duration: animationDuration), value: currentSubviewIndex)
    }
    
    init(currentSubviewIndex: Binding<Int>, currentSubviewDepth: Binding<Int>, @ViewBuilder viewByIndex: @escaping (Int) -> SubviewContent, numofIndexes: Int = 1) {
        self._currentSubviewIndex = currentSubviewIndex
        self._currentSubviewDepth = currentSubviewDepth
        self.viewByIndex = viewByIndex
        self.numOfIndexes = numofIndexes
    }
    
    private struct StackNavigationSubview<Content>: View where Content: View {
        
        @Binding var currentIndex: Int
        @Binding var currentDepth: Int
        @Binding var lastToMove: Bool
        let contentView: () -> Content
        
        var body: some View {
            VStack {
                if (self.currentDepth > 0){
                    Button(action: {
                        if (currentDepth == 1) {
                            currentIndex = 0
                        } else if (currentDepth == 2){
                            currentIndex = 1
                        }
                        currentDepth = max(0, currentDepth - 1)
                        lastToMove = false
                    }) {
                        Label("Back", systemImage: "arrowtriangle.left")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    //push the button to leftmost position
                    .leftAligned()
                    .padding(.horizontal).padding(.vertical, 4)
                }
                contentView() // Main view content
            }
        }
    }
}
