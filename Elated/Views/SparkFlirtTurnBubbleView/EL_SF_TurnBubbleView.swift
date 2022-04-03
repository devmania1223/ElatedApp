//
//  EL_SF_TurnBubbleView.swift
//  Elated
//
//  Created by admin on 6/22/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit

class EL_SF_TurnBubbleView: UIView {

    var turn: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        Turn_bubble.drawCanvas(frame: rect, resizing: .aspectFit, turn: turn)
    }

}
