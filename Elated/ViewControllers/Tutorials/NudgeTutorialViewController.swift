//
//  NudgeTutorialViewController.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class NudgeTutorialViewController: BaseViewController {
  @IBOutlet var gotItButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func bind() {
    super.bind()
    gotItButton.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      let vc = FavoritesTutorialViewController.xib()
      self.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: rx.disposeBag)
  }
}
