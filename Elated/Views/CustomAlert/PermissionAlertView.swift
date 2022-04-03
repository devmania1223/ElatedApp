//
//  PermissionAlertView.swift
//  Elated
//
//  Created by John Lester Celis on 2/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

enum PermissionType: String {
  case camera
  case photo
  case location
}

final class PermissionAlertView: AlertView {
  @IBOutlet private var doneButton: UIButton!
  @IBOutlet private var imageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var messageLabel: UILabel!

  var permissionType: PermissionType = .camera {
    didSet {
      updateView()
    }
  }

  // MARK: - Life Cycle

  override func awakeFromNib() {
    super.awakeFromNib()

    self.doneButton.layer.masksToBounds = true

    backgroundColor = UIColor.black.withAlphaComponent(0.8)
    layer.backgroundColor = backgroundColor?.cgColor
  }

  // MARK: - Private Methods

  @IBAction private func close(_ sender: Any) {
    hide(true)
  }

  @IBAction private func allowAccessTapped(_ sender: Any) {
    if let url = UIApplication.openSettingsURLString.urlValue() {
      Util.openURL(url: url)
    }

    hide(true)
  }

  // MARK: - Private

  private func updateView() {
    if self.permissionType == .location {
        self.titleLabel.text = "permission.alert.title".localizedFormat("\(self.permissionType.rawValue)")
       self.messageLabel.text = "permission.location.alert.message".localized
    } else if self.permissionType == .photo {
        self.titleLabel.text = "permission.alert.title".localizedFormat("\(self.permissionType.rawValue)")
        self.messageLabel.text = "permission.photo.alert.message".localized
    } else {
        self.titleLabel.text = "permission.alert.title".localizedFormat("\(self.permissionType.rawValue)")
      self.messageLabel.text = "permission.camera.alert.message".localized
    }
    self.imageView.image = UIImage(named: "\(self.permissionType.rawValue)_permission")
  }
}
