//
//  StackNavigationView.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//https://stackoverflow.com/questions/61424225/macos-swiftui-navigation-for-a-single-view
//https://www.avanderlee.com/swiftui/conditional-view-modifier/

import SwiftUI

struct StackNavigationView<SubviewContent>: View where SubviewContent: View {
    
    @Binding var currentSubviewIndex: Int
    @Binding var currentSubviewDepth: Int
    let viewByIndex: (Int) -> SubviewContent
    @State var previousSubviewIndexes: [Int] = []
    
    var body: some View {
        VStack {
            VStack{
                //0 means topmost layer
                StackNavigationSubview(currentIndex: self.$currentSubviewIndex, currentDepth: self.$currentSubviewDepth) {
                    self.viewByIndex(self.currentSubviewIndex)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .if(!previousSubviewIndexes.isEmpty && previousSubviewIndexes.last! < currentSubviewDepth){
                    $0.transition(AnyTransition.move(edge: .trailing)).animation(.default)
                }
                .if(previousSubviewIndexes.isEmpty || previousSubviewIndexes.last! > currentSubviewDepth){
                    $0.transition(AnyTransition.move(edge: .leading)).animation(.default)
                }
                .onAppear(){
                    previousSubviewIndexes.append(currentSubviewIndex)
                }
            }
        }
    }
    
    init(currentSubviewIndex: Binding<Int>, currentSubviewDepth: Binding<Int>, @ViewBuilder viewByIndex: @escaping (Int) -> SubviewContent) {
        self._currentSubviewIndex = currentSubviewIndex
        self._currentSubviewDepth = currentSubviewDepth
        self.viewByIndex = viewByIndex
    }
    
    private struct StackNavigationSubview<Content>: View where Content: View {
        
        @Binding var currentIndex: Int
        @Binding var currentDepth: Int
        let contentView: () -> Content
        
        var body: some View {
            VStack {
                if (self.currentDepth > 0){
                    HStack { // Back button
                        Button(action: {
                        }) {
                            Label("Back", systemImage: "arrowtriangle.left")
                        }.buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                    .padding(.horizontal).padding(.vertical, 4)
                }
                contentView() // Main view content
            }
        }
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
