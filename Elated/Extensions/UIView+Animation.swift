//
//  UIView+Animation.swift
//  Elated
//
//  Created by Rey Felipe on 6/16/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UIView {
    // Usage: insert view.fadeTransition right before changing content
    // Example:
    // label.fadeTransistion(1.0)
    // label.text = "New Text"
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
