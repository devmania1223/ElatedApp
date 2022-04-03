//
//  UILabel+Extensions.swift
//  Elated
//
//  Created by Rey Felipe on 7/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func addShadow(color: UIColor = .elatedPrimaryPurple , radius: CGFloat = 1.0, opacity: Float = 0.5){
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }
    
}
