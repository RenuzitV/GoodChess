//
//  ScreenUtils.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 16/08/2022.
//

import Foundation
import SwiftUI

//viewport height
public func vh(_ x: Double) -> CGFloat{
    return screenHeight*x
}

//viewport width
public func vw(_ x: Double) -> CGFloat{
    return screenWidth*x
}
