//
//  UIViewController+Extensions.swift
//  Elated
//
//  Created by admin on 6/9/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

extension UIViewController {
    
    func presentAlert(title: String?, message: String?, callback: (()->Void)?) {
        let alertViewCtrl = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
        
        alertViewCtrl.setValue(NSAttributedString(string: title ?? "",
                                                  attributes: [NSAttributedString.Key.font : UIFont.futuraBold(17),
                                                               NSAttributedString.Key.foregroundColor : UIColor.white]),
                               forKey: "attributedTitle")
        
        alertViewCtrl.setValue(NSAttributedString(string: message ?? "",
                                                  attributes: [NSAttributedString.Key.font : UIFont.futuraBook(15),
                                                               NSAttributedString.Key.foregroundColor : UIColor.white]),
                               forKey: "attributedMessage")
        
        alertViewCtrl.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .elatedSecondaryPurple
        alertViewCtrl.view.tintColor = .white
        
        let okAction = UIAlertAction(title: "common.ok".localized, style: .default) { _ in
            callback?()
        }
        alertViewCtrl.addAction(okAction)
        self.present(alertViewCtrl, animated: true, completion: nil)
    }
    
    @discardableResult public func presentAlert(title: String?,
                                                message: String?,
                                                buttonTitles: [String]? = nil,
                                                highlightedButtonIndex: Int? = nil,
                                                completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("common.ok".localized)
        }

        alertController.setValue(NSAttributedString(string: title ?? "",
                                                  attributes: [NSAttributedString.Key.font : UIFont.futuraBold(17),
                                                               NSAttributedString.Key.foregroundColor : UIColor.white]),
                               forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message ?? "",
                                                  attributes: [NSAttributedString.Key.font : UIFont.futuraBook(15),
                                                               NSAttributedString.Key.foregroundColor : UIColor.white]),
                               forKey: "attributedMessage")
        
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .elatedSecondaryPurple
        alertController.view.tintColor = .white
        
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        
        present(alertController, animated: true, completion: nil)
        return alertController
    }

    func setupNavigationBar(_ foregroundColor: UIColor = .elatedPrimaryPurple,
                            font: UIFont = .futuraBook(17),
                            tintColor: UIColor = .elatedPrimaryPurple,
                            backgroundColor: UIColor? = nil,
                            backgroundImage: UIImage? = nil,
                            additionalBarHeight: Bool = false,
                            addBackButton: Bool = false) {
        
        if #available(iOS 13.0, *) {
            let textAttributes = [
                NSAttributedString.Key.foregroundColor: foregroundColor,
                NSAttributedString.Key.font: font,
            ]
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundImage = backgroundImage
            appearance.backgroundColor = backgroundColor
            appearance.titleTextAttributes = textAttributes
            if backgroundImage == nil {
                appearance.shadowColor = .clear
                appearance.shadowImage = UIImage()
            }
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.standardAppearance = appearance
            navigationItem.compactAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
            self.navigationController?.navigationBar.tintColor = tintColor
            self.navigationController?.navigationBar.barTintColor = backgroundColor

            if additionalBarHeight {
                //self.navigationController?.additionalSafeAreaInsets.top = 10
            }
            
            let textAttributes = [
                NSAttributedString.Key.foregroundColor: foregroundColor,
                NSAttributedString.Key.font: font,
            ]
            
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        }

        if addBackButton {
            let backButton = UIBarButtonItem.createBackButton()
            backButton.tintColor = tintColor
            self.navigationItem.leftBarButtonItem = backButton
            backButton.rx.tap.bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: rx.disposeBag)
        }
                
    }
    
    func createMenu(_ vc: UIViewController) -> SideMenuNavigationController {
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.presentationStyle = .menuSlideIn
        menu.leftSide = true
        menu.menuWidth = UIScreen.main.bounds.width * 0.7
        menu.setNavigationBarHidden(true, animated: false)
        return menu
    }
    
}

extension UIViewController {
    /// Hides the keyboard if the user taps outside the keyboard
    func hideKeyboardWhenTappedAround() {
      let tap = UITapGestureRecognizer(
        target: self,
        action: #selector(UIViewController.dismissKeyboard)
      )
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }

    /// Dismiss the keyboard
    @objc func dismissKeyboard() {
      self.view.endEditing(true)
    }
}

extension UIViewController {
    
    func goBack(to viewController: AnyClass) {
        guard let nav = navigationController else { return }
        guard let vc = nav.viewControllers.last(where: { $0.isKind(of: viewController) }) else { return }
        nav.popToViewController(vc, animated: true)
    }
    
}
