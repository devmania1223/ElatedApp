//
//  UITextField+DesignField.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UITextField {
    
    func customizeTextField(_ isSecure: Bool,
                            leftImage: UIImage?,
                            rightImage: UIImage?,
                            placeholder: String,
                            colorTheme: UIColor,
                            borderWidth: CGFloat,
                            cornerRadius: CGFloat,
                            spacerWidth: CGFloat = 45) {

        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: spacerWidth, height: cornerRadius * 2))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: spacerWidth, height: cornerRadius * 2))

        let leftImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 19, height: cornerRadius * 2))
        leftImageView.tag = 1000
        let rightImageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 18, height: cornerRadius * 2))
        rightImageView.tag = 1001
        leftImageView.image = leftImage?.withRenderingMode(.alwaysTemplate)
        rightImageView.image = rightImage?.withRenderingMode(.alwaysTemplate)
        leftImageView.tintColor = colorTheme
        rightImageView.tintColor = colorTheme

        leftImageView.contentMode = .scaleAspectFit
        rightImageView.contentMode = .scaleAspectFit

        leftView.addSubview(leftImageView)
        rightView.addSubview(rightImageView)

        backgroundColor = .alabasterSolid
        self.leftView = leftView
        self.rightView = rightView
        isSecureTextEntry = isSecure
        keyboardType = isSecure ? .default : .emailAddress
        font = .futuraBook(14)
        leftViewMode = .always
        rightViewMode = .always
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = colorTheme.cgColor
        attributedPlaceholder = NSAttributedString(
          string: placeholder.localized,
          attributes: [
            NSAttributedString.Key.foregroundColor:
                colorTheme
          ]
        )
    }
    
    /* Default for 50 in height */
    static func createNormalTextField(_ placeholder: String,
                                      font: UIFont = .futuraBook(14),
                                      textColor: UIColor = .elatedPrimaryPurple,
                                      borderWidth: CGFloat = 0.25,
                                      cornerRadius: CGFloat = 25) -> UITextField {
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 26, height: cornerRadius * 2))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 26, height: cornerRadius * 2))
                
        let textField = UITextField()
        textField.leftView = leftView
        textField.rightView = rightView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.font = font
        textField.backgroundColor = .alabasterSolid
        textField.attributedPlaceholder = NSAttributedString(string: placeholder.localized,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.sonicSilver])
        textField.layer.borderWidth = borderWidth
        textField.layer.cornerRadius = cornerRadius
        textField.layer.borderColor = UIColor.sonicSilver.cgColor
        textField.textColor = textColor
        
        return textField
    }
    
}
