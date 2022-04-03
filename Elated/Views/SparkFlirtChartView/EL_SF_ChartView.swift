//
//  EL_SF_ChartView.swift
//  Elated
//
//  Created by admin on 6/19/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import Foundation
import UIKit

class EL_SF_ChartView: UIView {

    var daysAgo: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        Sparkflirt_chart.drawCanvas(frame: rect, resizing: .aspectFit, daysLeft: 5 - daysAgo)
    }
}
