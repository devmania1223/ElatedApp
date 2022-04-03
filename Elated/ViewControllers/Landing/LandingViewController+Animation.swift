//
//  LandingViewController+Animation.swift
//  Elated
//
//  Created by Marlon on 2021/2/22.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension LandingViewController {
    
    func setupAnimations() {
        
        let centerPos = CGPoint(x: contentView.frame.width / 2, y: logo.bounds.maxY + logo.frame.height)
        let diff = (rotateView.frame.size.width - logo.frame.size.width) / 4.5
        let tWidth = rotateView.frame.size.width + 10
        let tHeight = rotateView.frame.size.height
        
        rotateView1 = UIView()
        addRotateView(roView: rotateView1, width: tWidth - diff, height: tHeight - diff, centerPos: centerPos)
        addCircles(roView: rotateView1, r: (tWidth - diff)/2, cntLine: 11.0)
        
        rotateView2 = UIView()
        addRotateView(roView: rotateView2, width: tWidth - diff * 2, height: tHeight - diff * 2, centerPos: centerPos)
        addCircles(roView: rotateView2, r: (tWidth - diff * 2)/2, cntLine: 9.0)
        
        rotateView3 = UIView()
        addRotateView(roView: rotateView3, width: tWidth - diff * 3, height: tHeight - diff * 3, centerPos: centerPos)
        addCircles(roView: rotateView3, r: (tWidth - diff * 3)/2, cntLine: 7.0)
        
        rotateViewFunc(roView: rotateView1, withDuration: 3)
        rotateViewFunc(roView: rotateView2, withDuration: 2.5)
        rotateViewFunc(roView: rotateView3, withDuration: 2)
    }
    
    func addRotateView(roView: UIView, width: CGFloat, height: CGFloat, centerPos: CGPoint) {
        roView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        roView.center = centerPos
        roView.backgroundColor = UIColor.clear
        contentView.addSubview(roView)
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
        }) { [weak self] success in
            self?.rotateViewFunc(roView: roView, withDuration: withDuration)
        }
    }
    
}
