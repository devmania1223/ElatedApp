//
//  UIBarButtonItem.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    var frame: CGRect? {
        return (value(forKey: "view") as? UIView)?.frame
    }
    
    var view: UIView? {
        return (value(forKey: "view") as? UIView)
    }

    static func createMenuButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "icon-hamburgermenu-purple").withRenderingMode(.alwaysTemplate),
                               style: .plain,
                               target: self,
                               action: nil)
    }
    
    static func createBackButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate),
                               style: .plain,
                               target: self,
                               action: nil)
    }
    
    static func createEditButton(_ tint: UIColor = .white) -> UIBarButtonItem {
        let button =  UIBarButtonItem(image: #imageLiteral(resourceName: "icon-edit").withRenderingMode(.alwaysTemplate),
                                      style: .plain,
                                      target: self,
                                      action: nil)
        button.tintColor = tint
        return button
    }
    
    static func createNotificationButton(_ tint: UIColor = .white) -> UIBarButtonItem {
       let button =  UIBarButtonItem(image: UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysTemplate),
                                      style: .plain,
                                      target: self,
                                      action: nil)
        button.tintColor = tint
        return button
    }
    
    static func createCheckButton(_ tint: UIColor = .white) -> UIBarButtonItem {
        let button =  UIBarButtonItem(image: #imageLiteral(resourceName: "icon-check").withRenderingMode(.alwaysTemplate),
                                      style: .plain,
                                      target: self,
                                      action: nil)
        button.tintColor = tint
        return button
    }
    
    static func creatTextButton(_ text: String, tint: UIColor = .white) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: text, style: .plain, target: self, action: nil)
        button.tintColor = tint
        return button
    }
    
}
