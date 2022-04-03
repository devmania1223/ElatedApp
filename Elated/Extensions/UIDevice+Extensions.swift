//
//  UIDevice+Extensions.swift
//  Elated
//
//  Created by Rey Felipe on 9/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

// Reference: https://stackoverflow.com/questions/52402477/ios-detect-if-the-device-is-iphone-x-family-frameless

import UIKit

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasTopNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        return window.safeAreaInsets.top > 20
    }
    
}
