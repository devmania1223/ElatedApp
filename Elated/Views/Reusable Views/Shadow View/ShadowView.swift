//
//  ShadowView.swift
//  Elated
//
//  Created by Rey Felipe on 8/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//
// Reference: https://stackoverflow.com/questions/37645408/uitableviewcell-rounded-corners-and-shadow

import UIKit

class ShadowView: UIView {
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.25
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
