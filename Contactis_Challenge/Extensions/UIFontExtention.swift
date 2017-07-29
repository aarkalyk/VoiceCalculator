//
//  UIFontExtention.swift
//  Contactis_Challenge
//
//  Created by ARKALYK AKASH on 7/30/17.
//  Copyright © 2017 ARKALYK AKASH. All rights reserved.
//

import Foundation
import UIKit

extension UIFont{
    static func SFRegular(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: ".SFUIText", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    static func SFDisplayLight(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: ".SFUIDisplay-Light", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    static func SFDisplayBold(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: ".SFUIDisplay-Bold", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}
