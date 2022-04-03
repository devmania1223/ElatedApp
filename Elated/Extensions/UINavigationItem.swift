//
//  UINavigationItem.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem {
  func hideBackBarItem() {
    setHidesBackButton(true, animated: false)
  }
}
