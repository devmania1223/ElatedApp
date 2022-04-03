//
//  EL_BubbleView.swift
//  Elated
//
//  Created by admin on 5/29/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit

protocol EL_BubbleViewDelegate : class {
    func bubbleViewDidFinishFilling(_ bubbleView: EL_BubbleView)
}

@IBDesignable
class EL_BubbleView: UIView {
    
    private static let outerFillRadius: CGFloat = 1.0
    private static let innerFillRadius: CGFloat = 0.8
    
    private static let fillStartAngle: CGFloat = -CGFloat.pi / 2
    private static let fillEndAngle: CGFloat = 2 * CGFloat.pi
    static let fillPart: CGFloat = 0
    
    private static let innerCircleRadius: CGFloat = 0.9
    
    private static let innerArcsRadius: CGFloat = 0.8
    private static let innerArc1StartAngle: CGFloat = CGFloat.pi * 1.63
    private static let innerArc2StartAngle: CGFloat = CGFloat.pi * 1.87
    private static let innerArc1EndAngle: CGFloat = CGFloat.pi * 0.035
    private static let innerArc2EndAngle: CGFloat = CGFloat.pi * 0.050
    
    private static let innerArcFillPart: CGFloat = CGFloat.pi * 0.053
    
    static let fillTime: TimeInterval = 1.25
    static let unfillTime: TimeInterval = 0.25
    
    var outerStrokeAnimationCanceled = false
    var innnerStrokeAnimationCanceled = false
    
    private let shapeLayer = CAShapeLayer()
    let outerFillLayer = CAShapeLayer()
    let innerFillLayer = CAShapeLayer()
    
    var contentView: UIView!
    private var contentLabel: UILabel!
    
    private var timer: Timer?
    
    var widthStrokeNormal: CGFloat = 2.0
    var widthStrokeSelected: CGFloat = 2.0
    var widthStrokeDragging: CGFloat = 2.0
    
    var isSelected: Bool = false {
        didSet {
            animateToNewState()
        }
    }
    
    var isDragging: Bool = false
    
    var isFilling: Bool = false {
        didSet {
            guard isFilling != oldValue else {
                return
            }
            
            if isFilling {
                animateStartFilling()
            }
            else {
                animateStopFilling()
            }
        }
    }
    
    var isFilled: Bool = false
    var isInnerCircleFilled: Bool = false
    
    var bubble: MDL_Bubble?{
        didSet{
            contentLabel.text = bubble?.title
        }
    }
    
    weak var delegate: EL_BubbleViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        contentView = UIView(frame: frame)
        contentLabel = UILabel(frame: frame)
        
        initLabel()
        initCircle()
        initInnerCircle()
        initOuterFillLayer()
        initArcs()
        initInnerFillLayer()
        
        contentView.addSubview(contentLabel)
        addSubview(contentView)
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let fullFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        contentView.bounds = fullFrame // Use bounds!!!
        
        let bubbleW = bounds.size.width
        let bubbleH = bounds.size.height
        let labelW = bubbleW * 0.825
        let labelH = bubbleH * 0.825
        contentLabel.frame = CGRect(x: (bubbleW - labelW) / 2, y: (bubbleH - labelH) / 2, width: labelW, height: labelH)
        contentLabel.layer.cornerRadius = labelW / 2
        contentLabel.layer.masksToBounds = true
    }
    
    private func initCircle() {
        isOpaque = false
        
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: CGFloat(bounds.size.width / 2),
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat.pi * 2,
                                      clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.lavanderFloral.cgColor
        shapeLayer.lineWidth = widthStrokeNormal
        
        self.contentView.layer.addSublayer(shapeLayer)
    }
    
    private func initInnerCircle() {
        
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: self.bounds.width / 2 * EL_BubbleView.innerCircleRadius,
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat.pi * 2.0,
                                      clockwise: true)
        let innerCircleLayer = CAShapeLayer()
        innerCircleLayer.path = circlePath.cgPath
        innerCircleLayer.fillColor = UIColor.palePurplePantone.cgColor
        
        self.contentView.layer.addSublayer(innerCircleLayer)
    }
    
    private func initOuterFillLayer() {
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        outerFillLayer.path = UIBezierPath(arcCenter: center,
                                           radius: self.bounds.width / 2 * EL_BubbleView.outerFillRadius,
                                           startAngle: EL_BubbleView.fillStartAngle,
                                           endAngle: EL_BubbleView.fillEndAngle,
                                           clockwise: true).cgPath
        
        outerFillLayer.fillColor = UIColor.clear.cgColor
        outerFillLayer.strokeColor = UIColor.elatedPrimaryPurple.cgColor
        outerFillLayer.lineWidth = 2
        outerFillLayer.strokeEnd = EL_BubbleView.fillPart
        outerFillLayer.lineCap = .round
        
        self.contentView.layer.addSublayer(outerFillLayer)
    }
    
    private func initArcs() {
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let bubbleArc1Layer = CAShapeLayer()
        bubbleArc1Layer.path = UIBezierPath(arcCenter: center,
                                           radius: bounds.width / 2 * EL_BubbleView.innerArcsRadius,
                                     startAngle: EL_BubbleView.innerArc1StartAngle,
                                     endAngle: CGFloat.pi * 1.17 + CGFloat.pi * 2.0,
                                     clockwise: true).cgPath
        
        bubbleArc1Layer.fillColor = UIColor.clear.cgColor
        bubbleArc1Layer.strokeColor = UIColor.lavanderFloral.cgColor
        bubbleArc1Layer.lineWidth = 1.25
        bubbleArc1Layer.strokeEnd = EL_BubbleView.innerArc1EndAngle
        bubbleArc1Layer.lineCap = .round
        contentView.layer.addSublayer(bubbleArc1Layer)
        
        let bubbleArc2Layer = CAShapeLayer()
        bubbleArc2Layer.path = UIBezierPath(arcCenter: center,
                                           radius: bounds.width / 2 * EL_BubbleView.innerArcsRadius,
                                     startAngle: EL_BubbleView.innerArc2StartAngle,
                                     endAngle: CGFloat.pi * 1.17 + CGFloat.pi * 2.0,
                                     clockwise: true).cgPath

        bubbleArc2Layer.fillColor = UIColor.clear.cgColor
        bubbleArc2Layer.strokeColor = UIColor.lavanderFloral.cgColor
        bubbleArc2Layer.lineWidth = 1.25
        bubbleArc2Layer.strokeEnd = EL_BubbleView.innerArc1EndAngle
        bubbleArc2Layer.lineCap = .round

        contentView.layer.addSublayer(bubbleArc2Layer)
    }
    
    private func initInnerFillLayer() {
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        innerFillLayer.path = UIBezierPath(arcCenter: center,
                                           radius: bounds.width / 2 * EL_BubbleView.innerFillRadius,
                                           startAngle: EL_BubbleView.fillStartAngle,
                                           endAngle: EL_BubbleView.fillEndAngle,
                                           clockwise: true).cgPath
        
        innerFillLayer.fillColor = UIColor.clear.cgColor
        innerFillLayer.strokeColor = UIColor.elatedPrimaryPurple.cgColor
        innerFillLayer.lineWidth = 1.25
        innerFillLayer.strokeEnd = EL_BubbleView.fillPart
        innerFillLayer.lineCap = .round
        
        contentView.layer.addSublayer(innerFillLayer)
    }
    
    private func initLabel() {
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .elatedPrimaryPurple
        contentLabel.font = .futuraLight(14)
        contentLabel.backgroundColor = .clear
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.minimumScaleFactor = 0.5
    }
    
    func animateToNewState() {
        if isDragging {
            animateColor(color: UIColor.lavanderFloral, completion: nil)
            animateCircleWidth(toValue: self.widthStrokeDragging, completion: nil)
        }
        else if isSelected {
            animateColor(color: UIColor.lavanderFloral,completion:nil)
            animateCircleWidth(toValue: self.widthStrokeSelected, completion: nil)
        }
        else {
            animateColor(color: UIColor.lavanderFloral, completion: nil)
            animateCircleWidth(toValue: self.widthStrokeNormal, completion: nil)
        }
    }
    
    func animateCircleWidth(toValue:CGFloat, completion:(() -> Void)?){
        CATransaction.begin()
        
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.fromValue = shapeLayer.lineWidth
        animation.toValue = toValue
        animation.duration = 0.1
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock(completion)
        shapeLayer.add(animation, forKey: "lineWidth")
        
        CATransaction.commit()
    }
    
    //REY: TODO Clean this later, is this even needed
    var isAnimatingScale = false

    private func getCurrentColor() -> UIColor {
        if isSelected{
            return .lavanderFloral
        }
        else if isDragging{
            return .lavanderFloral
        }
        else{
            return .lavanderFloral
        }
    }
    
    func animateColor(color: UIColor, completion: (() -> Void)?) {
        CATransaction.begin()
        
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = UIColor.purple // tintColor.cgColor
        animation.toValue = color.cgColor
        animation.duration = 0.2
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock(completion)
        shapeLayer.add(animation, forKey: "strokeColor")

        CATransaction.commit()
    }
    
    func animateDisappearance(completion:((EL_BubbleView) -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            self.alpha = 0
            
        }, completion: { finished in
            completion?(self)
        })
    }
}
