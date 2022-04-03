//
//  UICollectionView+Extensions.swift
//  Elated
//
//  Created by Rey Felipe on 7/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .silver
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = .futuraMedium(15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
