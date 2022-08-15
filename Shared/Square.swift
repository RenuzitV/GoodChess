//
//  Square.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import Foundation
import SwiftUI

struct Square{
    var x : Int = 1
    var y : Int = 1
    var color : Color = .brown
    var piece : Optional<Piece> = nil
}
