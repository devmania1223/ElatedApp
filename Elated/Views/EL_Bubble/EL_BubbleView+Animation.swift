//
//  EL_BubbleView+Animation.swift
//  Elated
//
//  Created by Rey Felipe on 6/17/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension EL_BubbleView {
    
    func animateStartFilling() {
        animateFilling(toProgress: 1.0, duration: EL_BubbleView.fillTime) { (sender) in
            self.isFilled = true
            self.animateInnerFilling(toProgress: 1.0, duration: EL_BubbleView.fillTime) { (sender) in
                self.isInnerCircleFilled = true
                self.delegate?.bubbleViewDidFinishFilling(self)
            }
        }
    }
    
    func animateStopFilling() {
        animateFilling(toProgress: 0.0, duration: EL_BubbleView.unfillTime) { sender in
            self.isFilled = false
        }
        animateInnerFilling(toProgress: 0.0, duration: EL_BubbleView.unfillTime) { sender in
            self.isInnerCircleFilled = false
        }
    }

    private func animateFilling(toProgress: CGFloat, duration: TimeInterval, completion:((EL_BubbleView) -> Void)? = nil) {
        // Outer Circle fill
        let strokeAnimationKey = "strokeEnd"
        
        let prevAnimation = outerFillLayer.animation(forKey: strokeAnimationKey)
        if prevAnimation != nil {
            outerStrokeAnimationCanceled = true
            outerFillLayer.removeAnimation(forKey: strokeAnimationKey)
        }
        
        CATransaction.begin()
        
        let animation = CABasicAnimation(keyPath: strokeAnimationKey)
        animation.fromValue = outerFillLayer.presentation()?.strokeEnd ?? outerFillLayer.strokeEnd
        animation.toValue = EL_BubbleView.fillPart + (1.0 - EL_BubbleView.fillPart) * toProgress
        animation.duration = duration
        animation.fillMode = .forwards
        outerFillLayer.strokeEnd = animation.toValue as! CGFloat
        
        CATransaction.setCompletionBlock {
            if !self.outerStrokeAnimationCanceled {
                completion?(self)
            }
            
            self.outerStrokeAnimationCanceled = false
        }
        outerFillLayer.add(animation, forKey: strokeAnimationKey)
        CATransaction.commit()
    }
    
    private func animateInnerFilling(toProgress: CGFloat, duration: TimeInterval, completion:((EL_BubbleView) -> Void)? = nil) {
        // Inner Circle fill
        let strokeAnimationKey = "strokeEnd"
        
        let prevAnimation = innerFillLayer.animation(forKey: strokeAnimationKey)
        if prevAnimation != nil {
            innnerStrokeAnimationCanceled = true
            innerFillLayer.removeAnimation(forKey: strokeAnimationKey)
        }
        
        CATransaction.begin()
        
        let animation = CABasicAnimation(keyPath: strokeAnimationKey)
        animation.fromValue = innerFillLayer.presentation()?.strokeEnd ?? innerFillLayer.strokeEnd
        animation.toValue = EL_BubbleView.fillPart + (1.0 - EL_BubbleView.fillPart) * toProgress
        animation.duration = duration
        animation.fillMode = .forwards
        innerFillLayer.strokeEnd = animation.toValue as! CGFloat
        
        CATransaction.setCompletionBlock {
            if !self.innnerStrokeAnimationCanceled {
                completion?(self)
            }
            
            self.innnerStrokeAnimationCanceled = false
        }
        innerFillLayer.add(animation, forKey: strokeAnimationKey)
        CATransaction.commit()
    }
    
    func animateExplosion(completion: ((EL_BubbleView) -> Void)?) {
        // Create explosion image
        let ivExplosion = UIImageView(image: #imageLiteral(resourceName: "firework"))
        ivExplosion.center = contentView.center
        ivExplosion.tintColor = .elatedSecondaryPurple
        addSubview(ivExplosion)
        
        let exactScale = bounds.width / ivExplosion.bounds.width
        ivExplosion.transform = CGAffineTransform.init(scaleX: exactScale, y: exactScale)
        
        // Animate bubblecontent
        UIView.animate(withDuration: 0.1, animations: {
            self.contentView.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
            self.contentView.alpha = 0
        })
        
        // Animate bubble explosion
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [ .curveLinear ], animations: {
            ivExplosion.transform = CGAffineTransform.identity.scaledBy(x: exactScale * 1.4, y: exactScale * 1.4)
            ivExplosion.alpha = 1
            
        }) { finished in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [ .curveEaseOut ], animations: {
                ivExplosion.transform = CGAffineTransform.identity.scaledBy(x: exactScale * 1.6, y: exactScale * 1.6)
                ivExplosion.alpha = 0
                
            }) { finished in
                completion?(self)
            }
        }
    }
    
}
