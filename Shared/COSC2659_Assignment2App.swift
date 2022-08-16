//
//  COSC2659_Assignment2App.swift
//  Shared
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import SwiftUI

@main
struct COSC2659_Assignment2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Stage())
        }
    }
}
