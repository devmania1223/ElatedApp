//
//  SpinnerView.swift
//  Elated
//
//  Created by John Lester Celis on 1/31/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import UIKit

class SpinnerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var rotateView: UIView!
    @IBOutlet weak var elatedLogo: UIImageView!
    
    var rotateView1: UIView!
    var circleViews = [UIView]()
    var cnt = 1
    var timer : Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        Bundle.main.loadNibNamed("SpinnerView", owner: self, options: nil)

        let centerPos = CGPoint(x: self.frame.width / 2, y: rotateView.frame.origin.y)
        let diff = (rotateView.frame.size.width - elatedLogo.frame.size.width) / 4.2
        let tWidth = rotateView.frame.size.width + 10
        let tHeight = rotateView.frame.size.height
        
        rotateView1 = UIView()
        addRotateView(roView: rotateView1, width: tWidth - diff, height: tHeight - diff, centerPos: centerPos)
        addCircles(roView: rotateView1, r: (tWidth - diff)/2, cntLine: 11.0)
        
        rotateViewFunc(roView: rotateView1, withDuration: 1.5)
        self.bringSubviewToFront(elatedLogo)
    }
    
    func addRotateView(roView: UIView, width: CGFloat, height: CGFloat, centerPos: CGPoint) {
        roView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        roView.center = centerPos
        roView.backgroundColor = UIColor.clear
        self.addSubview(roView)
    }
    
    func addCircles(roView: UIView, r: CGFloat, cntLine: CGFloat) {
        //m_imgLogo.center
        let centerPos = CGPoint(x: roView.bounds.midX, y: roView.bounds.midY)
        var i : CGFloat = 0.0
        var alphaLine : CGFloat = 0
        while i < 2 * CGFloat.pi {
            let x = r * cos(i)
            let y = r * sin(i)
            
            let circleView = UIView()
            circleView.frame = CGRect(x: 0, y: 0, width: 6, height: 6)
            circleView.backgroundColor = UIColor.white
            let circlePos = CGPoint(x: centerPos.x + x, y: centerPos.y - y)
            circleView.center = circlePos
            roView.addSubview(circleView)
            circleView.layer.cornerRadius = 3
            
            circleView.alpha = alphaLine / cntLine
            alphaLine = alphaLine + 1
            if (alphaLine >= cntLine) {
                alphaLine = 0
            }
            
            i = i + CGFloat.pi / (cntLine * 2)
            
        }
    }
    
    func rotateViewFunc(roView: UIView, withDuration: TimeInterval) {
        
        UIView.animate(withDuration: withDuration, delay: 0.0, options: .curveLinear, animations: {
            roView.transform = roView.transform.rotated(by: -CGFloat.pi/2)
        }) { (success) in
            self.rotateViewFunc(roView: roView, withDuration: withDuration)
        }
    }
}
