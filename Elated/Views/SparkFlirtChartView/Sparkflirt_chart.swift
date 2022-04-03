//
//  EL_SF_ChartView.swift
//  Elated
//
//  Created by admin on 6/19/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit

public class Sparkflirt_chart : NSObject {

    //// Drawing Methods

    @objc dynamic public class func drawCanvas(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 25, height: 25), resizing: ResizingBehavior = .aspectFit, daysLeft: Int = 4) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Color Declarations
        let color = UIColor(red: 0.957, green: 0.808, blue: 0.278, alpha: 1.000)
        let shadowColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.500)
        let color2 = UIColor(red: 0.502, green: 0.239, blue: 0.663, alpha: 1.000)

        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowBlurRadius = 4

        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 6, y: 6, width: 25, height: 25))
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        color.setFill()
        ovalPath.fill()
        context.restoreGState()

        //// Oval 2 Drawing
        let oval2Rect = CGRect(x: 6, y: 6, width: 25, height: 25)
        let oval2Path = UIBezierPath()
        let startAngle = -CGFloat(72 * daysLeft + 90) * CGFloat.pi/180
        oval2Path.addArc(withCenter: CGPoint(x: oval2Rect.midX, y: oval2Rect.midY), radius: oval2Rect.width / 2, startAngle: startAngle, endAngle: -90 * CGFloat.pi/180, clockwise: true)
//        oval2Path.addArc(withCenter: CGPoint(x: oval2Rect.midX, y: oval2Rect.midY), radius: oval2Rect.width / 2, startAngle: -378 * CGFloat.pi/180, endAngle: -90 * CGFloat.pi/180, clockwise: true)
        oval2Path.addLine(to: CGPoint(x: oval2Rect.midX, y: oval2Rect.midY))
        oval2Path.close()

        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        color2.setFill()
        oval2Path.fill()
        context.restoreGState()

    }

    @objc(Sparkflirt_chartResizingBehavior)
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
