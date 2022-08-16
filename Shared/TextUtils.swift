//
//  TextUtils.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//
// 	https://www.fivestars.blog/articles/swiftui-share-layout-information/

import Foundation
import SwiftUI

//MARK: left aligned
struct LeftAligned: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
        }
    }
}

//MARK: right aligned
struct RightAligned: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
        }
    }
}

//MARK: center aligned
struct CenterAligned: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

//MARK: extension for alignments
extension View {
    func leftAligned() -> some View {
        return self.modifier(LeftAligned())
    }
    func rightAligned() -> some View {
        return self.modifier(RightAligned())
    }
    func centerAligned() -> some View {
        return self.modifier(CenterAligned())
    }
}
