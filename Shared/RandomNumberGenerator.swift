//
//  RandomNumberGenerator.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 17/11/2023.
//

import Foundation

struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        // Example of a simple pseudo-random number generation algorithm
        state &+= 0x9e3779b97f4a7c15
        var tmp = state
        tmp = (tmp ^ (tmp >> 30)) &* 0xbf58476d1ce4e5b9
        tmp = (tmp ^ (tmp >> 27)) &* 0x94d049bb133111eb
        return tmp ^ (tmp >> 31)
    }
}
