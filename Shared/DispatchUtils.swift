//
//  DispatchUtils.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 27/09/2022.
//https://stackoverflow.com/questions/24056205/how-to-use-background-thread-in-swift

import Foundation

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
    static func background(delay: Double = 0.0, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
    static func background(background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.async(execute: {
                    completion()
                })
            }
        }
    }

}
