//
//  UIWindow+Extensions.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/27/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UIWindow {
  var visibleViewController: UIViewController? {
    return UIWindow.visibleViewController(from: rootViewController)
  }

  static var key: UIWindow? {
    if #available(iOS 13, *) {
      return UIApplication.shared.windows.first { $0.isKeyWindow }
    } else {
      return UIApplication.shared.keyWindow
    }
  }

  static func visibleViewController(from vc: UIViewController?) -> UIViewController? {
    if let nc = vc as? UINavigationController {
      return UIWindow.visibleViewController(from: nc.visibleViewController)
    } else if let tc = vc as? UITabBarController {
      return UIWindow.visibleViewController(from: tc.selectedViewController)
    } else {
      if let pvc = vc?.presentedViewController {
        return UIWindow.visibleViewController(from: pvc)
      } else {
        return vc
      }
    }
  }
}
