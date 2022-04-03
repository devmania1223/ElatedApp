//
//  MatchProfileTutorialsViewController.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class MatchProfileTutorialsViewController: BaseViewController {
  @IBOutlet var continueButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func bind() {
    super.bind()
    continueButton.rx.tap.bind { [weak self] in
      guard let self = self else { return }
    }.disposed(by: rx.disposeBag)
  }
}
