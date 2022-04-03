//
//  UIButton.swift
//  Elated
//
//  Created by Marlon on 2021/3/11.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UIButton {

    //with 50 height and 25 fix radius
    static func createCommonBottomButton(_ text: String) -> UIButton {
        let button = UIButton()
        button.setTitle(text.localized, for: .normal)
        button.backgroundColor = .elatedPrimaryPurple
        button.titleLabel?.font = .futuraBook(14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }
    
    static func createButtonWithShadow(_ text: String, with shadow: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(text.localized, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = .futuraBook(14)
        button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        button.layer.cornerRadius = 25
        //Shadow
        if shadow {
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 0.8
            button.layer.shadowRadius = 0.0
            button.layer.masksToBounds = false
        }

        return button

    }
    
}
