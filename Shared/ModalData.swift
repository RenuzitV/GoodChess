//
//  ModalData.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 17/08/2022.
//

import Foundation
import SwiftUI
import AVFAudio

public var backgroundColor: Color {
    Color(0xf2c363).opacity(0.2)
}

func load<T: Decodable>(_ filename: String) -> T? {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        let decoded : T = try decoder.decode(T.self, from: data)
        print("loaded from \(filename) sucessfully.")
        return decoded
    } catch {
        print("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    return nil
}

func save<T: Encodable>(_ filename: String,_ data: T){

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedData = try encoder.encode(data)
        try encodedData.write(to: file)
        print("wrote to \(filename) sucessfully.")
        //debug
//        print(String(data: encodedData, encoding: .utf8))
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
