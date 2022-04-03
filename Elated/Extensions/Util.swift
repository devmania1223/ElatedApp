//
//  Util.swift
//  Elated
//
//  Created by John Lester Celis on 1/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import Photos

enum AuthorizationStatus {
  case authorized, notDetermined, denied, restricted, limited
}

enum ElatedDateFormat {
    case backend
    case chat
}

struct Util {
    
    static let screenHeight = UIScreen.main.nativeBounds.height
    static let heigherThanIphone6 = screenHeight >= 1334.0
    
    static func setRootViewController(_ viewController: UIViewController,
                                      animated: Bool = true,
                                      completion: (() -> Void)? = nil) {
        
      let delegate = UIApplication.shared.delegate as! AppDelegate
      let snapshot: UIView = (delegate.window?.snapshotView(afterScreenUpdates: true))!
      viewController.view.addSubview(snapshot)
      delegate.window?.rootViewController = viewController

      if animated {
        UIView.animate(withDuration: 0.5, animations: { () in
          snapshot.layer.opacity = 0
          snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: { _ in
          snapshot.removeFromSuperview()
          completion?()
        })
      } else {
        snapshot.removeFromSuperview()
        completion?()
      }
    }
    
    static func openURL(url: URL) {
      // NOTE: Removed deprecated openURL
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    
}
