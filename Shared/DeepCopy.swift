//
//  DeepCopy.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//https://stackoverflow.com/questions/24754559/how-to-do-deep-copy-in-swift

import Foundation

class DeepCopy {
    //Used to expose generic
    static func copy<T:Codable>(of object:T) -> T?{
       do{
           let json = try JSONEncoder().encode(object)
           return try JSONDecoder().decode(T.self, from: json)
       }
       catch let error{
           print(error)
           return nil
       }
    }
}
