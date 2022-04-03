//
//  EL_TOTProgressView.swift
//  Elated
//
//  Created by admin on 6/1/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit

class EL_TOTProgressView: UIView {

    var progressStep: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        EL_TOTProgressDraw.drawCanvas(frame: rect, resizing: .aspectFit, step: progressStep)
    }
}
