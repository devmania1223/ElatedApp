//
//  SSColorRadioButton.swift
//  Elated
//
//  Created by Rey Felipe on 7/1/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

//  Reference: https://github.com/shamasshahid/SSRadioButtonsController

import UIKit
@IBDesignable

class SSColorRadioButton: UIButton {
    
    fileprivate var circleLayer = CAShapeLayer()
    fileprivate var outerCircleLayer = CAShapeLayer()
    override var isSelected: Bool {
        didSet {
            toggleButon()
        }
    }
    /**
     Color of the radio button circle. Default value is UIColor red.
     */
    @IBInspectable var circleColor: String = StoryShareColor.red.rawValue {
        didSet {
            //StoryShareColor won't be nil
            circleLayer.strokeColor = StoryShareColor(rawValue: circleColor)!.getColor().cgColor
            circleLayer.fillColor = StoryShareColor(rawValue: circleColor)!.getColor().cgColor
            toggleButon()
        }
    }
    
    /**
     Radius of RadioButton circle.
     */
    @IBInspectable var circleRadius: CGFloat = 15.0
    @IBInspectable override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    fileprivate func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleFrame.origin.x =  bounds.width / 2 - circleFrame.width / 2
            //0 + circleLayer.lineWidth
        circleFrame.origin.y = bounds.height / 2 - circleFrame.height / 2
        return circleFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    init(color: StoryShareColor) {
        super.init(frame: .zero)
        circleColor = color.rawValue
        initialize()
    }
    
    fileprivate func initialize() {
        circleLayer.frame = bounds
        circleLayer.lineWidth = 0.5
        circleLayer.strokeColor = StoryShareColor(rawValue: circleColor)!.getColor().cgColor
        circleLayer.fillColor = StoryShareColor(rawValue: circleColor)!.getColor().cgColor
        layer.addSublayer(circleLayer)
        
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = 2
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        outerCircleLayer.strokeColor = UIColor.clear.cgColor
        outerCircleLayer.opacity = 0.4
        layer.addSublayer(outerCircleLayer)
        
        toggleButon()
    }
    /**
     Toggles selected state of the button.
     */
    func toggleButon() {
        if isSelected {
            outerCircleLayer.fillColor = StoryShareColor(rawValue: circleColor)!.getColor().cgColor
        } else {
            outerCircleLayer.fillColor = UIColor.clear.cgColor
        }
    }
    
    fileprivate func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }
    
    fileprivate func outerCirclePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame().insetBy(dx: -4, dy: -4))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = bounds
        circleLayer.path = circlePath().cgPath
        outerCircleLayer.frame = bounds
        outerCircleLayer.path = outerCirclePath().cgPath
    }
    
    override func prepareForInterfaceBuilder() {
        initialize()
    }
}

