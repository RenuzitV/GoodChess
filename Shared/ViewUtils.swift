//
//  ViewUtils.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 17/08/2022.
//
//https://www.avanderlee.com/swiftui/conditional-view-modifier/

import Foundation
import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, yesTransform: (Self) -> Content) -> some View {
        if condition {
            yesTransform(self)
        } else {
            self
        }
    }
}

        // let transform = { (self) -> some View in
        //     if condition {
        //         return yesTransform(self)
        //     } else {
        //         return self
        //     }
        // }