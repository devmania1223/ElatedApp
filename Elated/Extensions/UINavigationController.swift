//
//  UINavigationController.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
  func hideNavBar(_ on: Bool = true) {
    setNavigationBarHidden(on, animated: false)
  }

  func setTintColor(withColor color: UIColor) {
    navigationBar.tintColor = color
  }

  func setNavBarColor(withColor color: UIColor) {
    navigationBar.barTintColor = color
  }

  func setTransparentNavBar(hideHairLine: Bool = true) {
    setNavigationBarHidden(false, animated: false)
    navigationBar.tintColor = .white
    navigationBar.isTranslucent = true
    navigationBar.backgroundColor = .clear

    if hideHairLine {
      navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationBar.shadowImage = UIImage()
    }
  }

  func setTransparentBar() {
    setNavigationBarHidden(false, animated: true)
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
  }
}
