//
//  UIView+Extensions.swift
//  Elated
//
//  Created by admin on 5/19/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable
    public var cornerRadius : CGFloat {
        get{
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        get {
            if let bColor = self.layer.borderColor {
                return UIColor(cgColor: bColor)
            }else {
                return nil
            }
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor? {
        get {
            if let sColor = self.layer.shadowColor {
                return UIColor(cgColor: sColor)
            } else {
                return nil
            }
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    public var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
}

enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

extension UIView {
    func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]

        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        default:
            break
        }

        self.layer.insertSublayer(gradient, at: 0)
    }
    
    //Add shadow layer on view
    func addShadowLayer() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.layer.shadowPath = UIBezierPath(rect: (self.bounds)).cgPath
            self.layer.shadowRadius = 5
            self.layer.shadowOffset = .zero
            self.layer.masksToBounds = false
            self.layer.shadowOpacity = 0.1
            self.layer.shadowColor = UIColor.black.cgColor
        }
    }
       
    func addShadowAllSides() {
        self.layer.shadowColor = UIColor.jet.cgColor
        self.layer.shadowOffset =  .zero
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 8
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
        
    func roundCorners(radius: CGFloat,
                      corners: CACornerMask) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func addGradientLayer(height: CGFloat) {
        let gradientView = UIImageView(image: #imageLiteral(resourceName: "black-gradient-ovelay"))
        gradientView.contentMode = .scaleToFill
        self.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}

extension Bundle {
  func loadView(name: String) -> UIView? {
    loadNibNamed(name, owner: nil, options: nil)?.first as? UIView
  }
}

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: IndexPath(row: row-1, section: section-1), at: .bottom, animated: animated)
            }
        }
    }
}

