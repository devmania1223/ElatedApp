//
//  EL_BubblesView+Animation.swift
//  Elated
//
//  Created by Rey Felipe on 6/16/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension EL_BubblesView {
    
    func springAnimation(duration: CGFloat, depth: CGFloat) {
        // Spring animation for bubbles view
        var springIt = CGAffineTransform.identity
        springIt = springIt.translatedBy(x: 0, y: depth)
        springIt = springIt.scaledBy(x: 0.25, y: 0.25)
        transform = springIt
        UIView.animate(withDuration: TimeInterval(duration), delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
}
