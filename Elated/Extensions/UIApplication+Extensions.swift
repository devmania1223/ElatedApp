//
//  UIApplication+Extensions.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/27/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
  class func topViewController(
    controller: UIViewController? = UIWindow.key?.rootViewController
  ) -> UIViewController? {
      //Use to present ALERTs and UIIMagePicker only
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}
