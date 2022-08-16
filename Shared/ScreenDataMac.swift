//
//  ScreenDataMac.swift
//  COSC2659_Assignment2 (iOS)
//
//  Created by Duy Nguyen Vu Minh on 13/08/2022.
//

import Foundation
import SwiftUI


// Screen height.
public var screenHeight: CGFloat {
    return NSScreen.main!.frame.height
}

// Screen width.
public var screenWidth: CGFloat {
    return screenHeight/16*9
//    return NSScreen.main!.frame.width
}

//define boardsize as a function of screen height, assuming a 16/9 resolution on a landscape screen
//doing this, we can assure that the board is at the same aspect ratio as on a phone
public var maxBoardSize : CGFloat {
    return screenHeight/16*9
}
