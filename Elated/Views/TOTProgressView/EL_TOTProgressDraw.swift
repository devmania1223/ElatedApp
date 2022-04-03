//
//  EL_TOTProgressDraw.swift
//  Elated
//
//  Created by admin on 6/1/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//



import UIKit

public class EL_TOTProgressDraw : NSObject {

    //// Drawing Methods

    @objc dynamic public class func drawCanvas(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 316, height: 40), resizing: ResizingBehavior = .aspectFit, step: Int = 0) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 316, height: 40), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 316, y: resizedFrame.height / 40)
        let resizedShadowScale: CGFloat = min(resizedFrame.width / 316, resizedFrame.height / 40)

        //// Color Declarations
        let yellow = UIColor(red: 0.957, green: 0.808, blue: 0.278, alpha: 1.000)
        let purple = UIColor(red: 0.416, green: 0.106, blue: 0.604, alpha: 1.000)

        //// Shadow Declarations
        let dropShadow1 = NSShadow()
        dropShadow1.shadowColor = UIColor.black.withAlphaComponent(0.5)
        dropShadow1.shadowOffset = CGSize(width: 0, height: 2)
        dropShadow1.shadowBlurRadius = 4

        //// yellow line - back progress line
        let oval3Path = UIBezierPath()
        oval3Path.move(to: CGPoint(x: 20.74, y: 21))
        oval3Path.addCurve(to: CGPoint(x: 159, y: 1), controlPoint1: CGPoint(x: 59.35, y: 8.43), controlPoint2: CGPoint(x: 107.19, y: 1))
        oval3Path.addCurve(to: CGPoint(x: 295.57, y: 20.45), controlPoint1: CGPoint(x: 210.05, y: 1), controlPoint2: CGPoint(x: 257.25, y: 8.22))
        yellow.setStroke()
        oval3Path.lineWidth = 2
        oval3Path.stroke()

        if(step > 0) {
            //// purple line - progress line
            let oval4Path = UIBezierPath()
            context.saveGState()
            oval4Path.move(to: CGPoint(x: 20.74, y: 21.5))
            if(step >= 1) {
                oval4Path.addCurve(to: CGPoint(x: 78.67, y: 7.75), controlPoint1: CGPoint(x: 38.31, y: 15.78), controlPoint2: CGPoint(x: 57.78, y: 11.13))
            }
            if (step >= 2) {
                oval4Path.addCurve(to: CGPoint(x: 134.29, y: 2.07), controlPoint1: CGPoint(x: 96.3, y: 4.9), controlPoint2: CGPoint(x: 114.94, y: 2.97))
            }
            if (step >= 3) {
                oval4Path.addCurve(to: CGPoint(x: 159, y: 1.5), controlPoint1: CGPoint(x: 142.41, y: 1.69), controlPoint2: CGPoint(x: 150.65, y: 1.5))
                oval4Path.addCurve(to: CGPoint(x: 188.21, y: 2.3), controlPoint1: CGPoint(x: 168.89, y: 1.5), controlPoint2: CGPoint(x: 178.64, y: 1.77))
            }
            if (step >= 4) {
                oval4Path.addCurve(to: CGPoint(x: 241.37, y: 8.09), controlPoint1: CGPoint(x: 206.7, y: 3.31), controlPoint2: CGPoint(x: 224.5, y: 5.28))
            }
            if (step >= 5) {
                oval4Path.addCurve(to: CGPoint(x: 295.57, y: 20.95), controlPoint1: CGPoint(x: 260.82, y: 11.32), controlPoint2: CGPoint(x: 279.02, y: 15.67))
            }
            
            context.setShadow(offset: CGSize(width: dropShadow1.shadowOffset.width * resizedShadowScale, height: dropShadow1.shadowOffset.height * resizedShadowScale), blur: dropShadow1.shadowBlurRadius * resizedShadowScale, color: (dropShadow1.shadowColor as! UIColor).cgColor)
            purple.setStroke()
            oval4Path.lineWidth = 3
            oval4Path.stroke()
            context.restoreGState()
        }
        
        //// left circle
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 3, y: 14, width: 22, height: 22))
        context.saveGState()
        context.setShadow(offset: CGSize(width: dropShadow1.shadowOffset.width * resizedShadowScale, height: dropShadow1.shadowOffset.height * resizedShadowScale), blur: dropShadow1.shadowBlurRadius * resizedShadowScale, color: (dropShadow1.shadowColor as! UIColor).cgColor)
        step > 0 ? purple.setFill() : yellow.setFill()
        ovalPath.fill()
        context.restoreGState()

        //// right circle
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 291, y: 14, width: 22, height: 22))
        context.saveGState()
        context.setShadow(offset: CGSize(width: dropShadow1.shadowOffset.width * resizedShadowScale, height: dropShadow1.shadowOffset.height * resizedShadowScale), blur: dropShadow1.shadowBlurRadius * resizedShadowScale, color: (dropShadow1.shadowColor as! UIColor).cgColor)
        step < 5 ? yellow.setFill() : purple.setFill()
        oval2Path.fill()
        context.restoreGState()
        
        context.restoreGState()

    }
    
    @objc(_0_5ResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
