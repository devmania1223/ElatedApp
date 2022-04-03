//
//  UIViewController+Xib.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func xib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
          return T(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
    
    func presentViewPopup(popup: UIView) {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        UIView.animate(withDuration: 0.4) {
            keyWindow?.addSubview(popup)
        }
    }
    
    func dismissViewPopup(popup: UIView, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut) {
            popup.removeFromSuperview()
        } completion: { _ in
            completion?()
        }
    }
    
}
