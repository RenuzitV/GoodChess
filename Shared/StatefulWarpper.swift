//
//  StatefulWarpper.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//https://developer.apple.com/forums/thread/118589

import Foundation
import SwiftUI

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
