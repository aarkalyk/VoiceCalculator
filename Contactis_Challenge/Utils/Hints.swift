//
//  Hints.swift
//  Contactis_Challenge
//
//  Created by ARKALYK AKASH on 7/30/17.
//  Copyright © 2017 ARKALYK AKASH. All rights reserved.
//

import Foundation
import UIKit

enum Sizes{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let expandedViewHeight = Sizes.screenHeight/2.0
    static let compressedViewHeight : CGFloat = 83.0
    static let controlAndSidePointDifference : CGFloat = 10.0
    static let recordButtonWidth : CGFloat = 60.0
}

struct Hints {
    static let recordInstructionText = "Press the record button below and tell me your problem"
    static let stopInstructionText = "Press the stop button below when you're done"
    static let errorInstructionText = "Please speak loudly and CLEARLY\nOkay? :)"
    static let expressionPlaceHolderText = "Make sure it's a hard one"
    static let expressionRecordingText = "Listening carefully..."
    static let computingText = "Give me sec..!"
    static let errorText = "Couldn't hear you :("
}
