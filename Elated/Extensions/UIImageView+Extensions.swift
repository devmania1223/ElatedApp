//
//  UIImageView+Extensions.swift
//  Elated
//
//  Created by Rey Felipe on 12/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func applyBlurEffect(_ style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
}
