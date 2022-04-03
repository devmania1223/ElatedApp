//
//  Turn_bubble.swift
//  Elated
//
//  Created by admin on 6/22/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit

public class Turn_bubble : NSObject {

    //// Drawing Methods

    @objc dynamic public class func drawCanvas(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 191, height: 86), resizing: ResizingBehavior = .aspectFit, turn: Int = 0) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 191, height: 86), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 191, y: resizedFrame.height / 86)


        //// Color Declarations
        let colorF4CE47 = UIColor(red: 0.957, green: 0.808, blue: 0.278, alpha: 1.000)

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 191, height: 57), cornerRadius: 12)
        colorF4CE47.setFill()
        rectanglePath.fill()

        if(turn == 1) {
            //// arrow_their_turn Drawing
            context.saveGState()
            context.translateBy(x: 147, y: 86.5)
            context.rotate(by: -90 * CGFloat.pi/180)

            let arrow_their_turnPath = UIBezierPath()
            arrow_their_turnPath.move(to: CGPoint(x: 29.5, y: 0))
            arrow_their_turnPath.addLine(to: CGPoint(x: 55.05, y: 15.75))
            arrow_their_turnPath.addLine(to: CGPoint(x: 3.95, y: 15.75))
            arrow_their_turnPath.close()
            colorF4CE47.setFill()
            arrow_their_turnPath.fill()

            context.restoreGState()
            

            //// txt_their_turn Drawing
            let txt_their_turnRect = CGRect(x: 24, y: 13, width: 143, height: 30)
            let txt_their_turnTextContent = "Their turn!"
            let txt_their_turnStyle = NSMutableParagraphStyle()
            txt_their_turnStyle.alignment = .center
            let txt_their_turnFontAttributes = [
                .font: UIFont.systemFont(ofSize: 28),
                .foregroundColor: UIColor.black,
                .paragraphStyle: txt_their_turnStyle,
            ] as [NSAttributedString.Key: Any]

            let txt_their_turnTextHeight: CGFloat = txt_their_turnTextContent.boundingRect(with: CGSize(width: txt_their_turnRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: txt_their_turnFontAttributes, context: nil).height
            context.saveGState()
            context.clip(to: txt_their_turnRect)
            txt_their_turnTextContent.draw(in: CGRect(x: txt_their_turnRect.minX, y: txt_their_turnRect.minY + (txt_their_turnRect.height - txt_their_turnTextHeight) / 2, width: txt_their_turnRect.width, height: txt_their_turnTextHeight), withAttributes: txt_their_turnFontAttributes)
            context.restoreGState()
        } else {

            //// arrow_your_turn Drawing
            context.saveGState()
            context.translateBy(x: 39, y: 27.5)
            context.rotate(by: -270 * CGFloat.pi/180)

            let arrow_your_turnPath = UIBezierPath()
            arrow_your_turnPath.move(to: CGPoint(x: 29.5, y: 0))
            arrow_your_turnPath.addLine(to: CGPoint(x: 55.05, y: 15.75))
            arrow_your_turnPath.addLine(to: CGPoint(x: 3.95, y: 15.75))
            arrow_your_turnPath.close()
            colorF4CE47.setFill()
            arrow_your_turnPath.fill()

            context.restoreGState()


            //// txt_your_turn Drawing
            let txt_your_turnRect = CGRect(x: 24, y: 13, width: 143, height: 30)
            let txt_your_turnTextContent = "Your turn!"
            let txt_your_turnStyle = NSMutableParagraphStyle()
            txt_your_turnStyle.alignment = .center
            let txt_your_turnFontAttributes = [
                .font: UIFont.systemFont(ofSize: 28),
                .foregroundColor: UIColor.black,
                .paragraphStyle: txt_your_turnStyle,
            ] as [NSAttributedString.Key: Any]

            let txt_your_turnTextHeight: CGFloat = txt_your_turnTextContent.boundingRect(with: CGSize(width: txt_your_turnRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: txt_your_turnFontAttributes, context: nil).height
            context.saveGState()
            context.clip(to: txt_your_turnRect)
            txt_your_turnTextContent.draw(in: CGRect(x: txt_your_turnRect.minX, y: txt_your_turnRect.minY + (txt_your_turnRect.height - txt_your_turnTextHeight) / 2, width: txt_your_turnRect.width, height: txt_your_turnTextHeight), withAttributes: txt_your_turnFontAttributes)
            context.restoreGState()
        }
        context.restoreGState()

    }




    @objc(Turn_bubbleResizingBehavior)
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
