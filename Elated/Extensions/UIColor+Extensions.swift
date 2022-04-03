//
//  UIColor+Extensions.swift
//  Elated
//
//  Created by admin on 6/1/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let appGreen = UIColor(hexString: "30ABB0")
    static let appBlue = UIColor(hexString: "1473E6")
    static let alabasterApprox = UIColor(hexString: "F9F9F9")
    static let alabasterSolid = UIColor(hexString: "FAFAFA")
    static let alabasterBlue = UIColor(hexString: "DFEEFF")
    static let alabasterBlueLight = UIColor(hexString: "ABD3FF")
    static let blizzardBlue = UIColor(hexString: "C2F5FF")
    static let brightYellowCrayola = UIColor(hexString: "FFAE2E")
    static let danger = UIColor(hexString: "DA6A6A")
    static let darkOrchid = UIColor(hexString: "8C4AD4")
    static let eerieBlack = UIColor(hexString: "262626")
    static let elatedPrimaryPurple = UIColor(hexString: "6A1B9A")
    static let elatedSecondaryPurple = UIColor(hexString: "531578")
    static let ghostWhite = UIColor(hexString: "FBF8FF")
    static let jet = UIColor(hexString: "3C3C3C")
    static let lavanderFloral = UIColor(hexString: "B08ADB")
    static let lightGray = UIColor(hexString: "D8D8D8")
    static let maximumYellowRed = UIColor(hexString: "FFC364")
    static let napiesYellow = UIColor(hexString: "FFDF64")
    static let palePurplePantone = UIColor(hexString: "F4EAFF")
    static let silver = UIColor(hexString: "C7C7C7")
    static let sonicSilver = UIColor(hexString: "757575")
    static let tuftsBlue = UIColor(hexString: "4A91D4")
    static let goGradient_FFAE2E = UIColor(hexString: "FFAE2E")
    static let grayColor = UIColor(hexString: "#757575")
    static let appLightSkyBlue = UIColor(hexString: "#DCEFFF")
    static let onlineGreen = UIColor(hexString: "#23CF55")
    
    // StoryShare Colors
    static let chestnut = UIColor(hexString: "803F25")
    static let ssRed = UIColor(hexString: "D96969")
    static let ssBlue = UIColor(hexString: "4A91D4")
    static let ssOrange = UIColor(hexString: "FF8F1F")
    static let ssMustard = UIColor(hexString: "D1B200")
    static let ssPink = UIColor(hexString: "FF82BA")
    static let ssGreen = UIColor(hexString: "54C479")
    static let ssViolet = UIColor(hexString: "8A4AD4")
    static let ssGray = UIColor(hexString: "737373")
    static let umber = UIColor(hexString: "685245")
    
    static let greenCheckColor = UIColor(hexString: "#7DC585")
    static let colorMain = UIColor(named: "cl_main")!
    
    //Page Control
    static let pageTintColor = UIColor(hexString: "#803DA9").withAlphaComponent(0.5)
    static let currentPageColor = UIColor(hexString: "#803CA9")
    
    static let grayLabelBorderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.5)
    static let fadedPurpleBackgroundColor = UIColor(red: 106/255, green: 27/255, blue: 154/255, alpha: 0.9)
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
