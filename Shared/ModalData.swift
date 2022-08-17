//
//  ModalData.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 17/08/2022.
//

import Foundation
import SwiftUI

public var backgroundColor: Color {
    Color(0xf2c363).opacity(0.2)
}

func save<T: Encodable>(_ filename: String,_ data: T){
    let dir = try? FileManager.default.url(for: .documentDirectory,
          in: .userDomainMask, appropriateFor: nil, create: true)

    guard let fileURL = dir?.appendingPathComponent(filename).appendingPathExtension("json") else {
        fatalError("Not able to create URL")
    }
    
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedData = try encoder.encode(data)
        print(String(data: encodedData, encoding: .utf8))
        try encodedData.write(to: fileURL)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func load<T: Decodable>(_ filename: String) -> T {
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
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

