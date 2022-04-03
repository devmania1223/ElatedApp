//
//  OrderedChoicesCollectionViewCell.swift
//  Elated
//
//  Created by Rey Felipe on 8/11/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class OrderedChoicesCollectionViewCell: UICollectionViewCell {

    static let identifier = "OrderedChoicesCollectionViewCell"
    
    var didDelete: (() -> Void)?
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .elatedPrimaryPurple
        label.font = .futuraMedium(14)
        label.text = "1"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews() {
        
        backgroundColor = .clear
        
        contentView.addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        initCircle()
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
    }
    
    private func initCircle() {
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: CGFloat(bounds.size.width / 2),
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat.pi * 2,
                                      clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.elatedPrimaryPurple.cgColor
        shapeLayer.lineWidth = 2.5
        circleView.layer.cornerRadius = CGFloat(bounds.size.width / 2)
        circleView.layer.addSublayer(shapeLayer)
    }
    
    func setData(_ order: Int, value: ThisOrThatOrderedChoicesPreference?) {
        if value == nil {
            label.text = "\(order)"
            label.textColor = .elatedPrimaryPurple
            label.font = .futuraMedium(14)
            circleView.backgroundColor = .white
        } else {
            label.text = value?.rawValue
            label.textColor = .white
            label.font = .futuraMedium(12)
            circleView.backgroundColor = .elatedPrimaryPurple
        }
    }
}
