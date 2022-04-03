//
//  AlertView.swift
//  Elated
//
//  Created by John Lester Celis on 2/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import SnapKit
import UIKit

/// Don't set to `final` being used as superclass
class AlertView: UIView {
  let animationDuration = 0.4

  func hide(_ animated: Bool) {
    if animated {
      UIView.animate(withDuration: self.animationDuration) {
        self.hide(false)
      }

    } else {
      self.removeFromSuperview()
      self.alpha = 0.0
    }
  }

  func show(_ animated: Bool) {
    if let window = UIApplication.shared.keyWindow {
      if animated {
        UIView.animate(withDuration: self.animationDuration) {
          self.show(false)
        }
      } else {
        window.addSubview(self)
        self.snp.makeConstraints { maker in
          maker.edges.equalToSuperview()
        }
        self.alpha = 1.0
      }
    }
  }
}
