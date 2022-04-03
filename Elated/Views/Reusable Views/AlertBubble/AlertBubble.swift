//
//  AlertBubble.swift
//  Elated
//
//  Created by Marlon on 2021/3/3.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class AlertBubble: UIView {

    private let imageView = UIImageView()
    
    let label: PaddingLabel = {
        let label = PaddingLabel()
        label.paddingLeft = 10
        label.paddingRight = 10
        label.paddingTop = 10
        label.paddingBottom = 10
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        label.numberOfLines = 0
        return label
    }()

    enum ArrowPosition {
        case topCenter
        case topLeft
        case topRight
        case bottomCenter
        case bottomLeft
        case bottomRight
        
        func getImage() -> UIImage {
            switch self {
            case .topCenter, .topLeft, .topRight:
                return #imageLiteral(resourceName: "icon_triangle").withRenderingMode(.alwaysTemplate)
            case .bottomCenter, .bottomLeft, .bottomRight:
                return #imageLiteral(resourceName: "icon_triangle_reversed").withRenderingMode(.alwaysTemplate)
            }
        }
        
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
    
    init(_ arrow: ArrowPosition,
         text: String,
         color: UIColor,
         dismissable: Bool = false,
         font: UIFont = .futuraBook(12),
         textColor: UIColor = .white) {
        
        super.init(frame: .zero)
        
        if dismissable {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        }
        
        initSubviews(arrow)
        
        imageView.tintColor = color
        imageView.image = arrow.getImage()
        
        label.text = text
        label.font = font
        label.textColor = textColor
        label.backgroundColor = color
        
    }
    
    init(_ arrow: ArrowPosition,
         attributedText: NSAttributedString,
         color: UIColor,
         dismissable: Bool = false) {
        
        super.init(frame: .zero)
        
        if dismissable {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        }
        
        initSubviews(arrow)
        
        imageView.tintColor = color
        imageView.image = arrow.getImage()
        
        label.attributedText = attributedText
        label.backgroundColor = color
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func initSubviews(_ arrow: ArrowPosition) {
        
        addSubview(imageView)
        addSubview(label)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.width.equalTo(14)
            
            switch arrow {
            case .topCenter:
                make.centerX.top.equalToSuperview()
                break
            case .topLeft:
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(6)
                break
            case .topRight:
                make.top.equalToSuperview()
                make.right.equalToSuperview().inset(6)
                break
            case .bottomCenter:
                make.top.equalTo(label.snp.bottom)
                make.centerX.bottom.equalToSuperview()
                break
            case .bottomLeft:
                make.top.equalTo(label.snp.bottom)
                make.left.equalToSuperview().offset(6)
                make.bottom.equalToSuperview()
                break
            case .bottomRight:
                make.top.equalTo(label.snp.bottom)
                make.right.equalToSuperview().inset(6)
                make.bottom.equalToSuperview()
                break
            }
        }
        
        
        label.snp.makeConstraints { make in
            switch arrow {
            case .topCenter, .topLeft, .topRight:
                make.top.equalTo(imageView.snp.bottom)
                make.bottom.left.right.equalToSuperview()
                break
            case .bottomCenter, .bottomLeft, .bottomRight:
                make.top.left.right.equalToSuperview()
                break
            }
        }
        
    }
    
}
