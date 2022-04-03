//
//  ReminderSentViewController.swift
//  Elated
//
//  Created by Rey Felipe on 12/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class ReminderSentViewController: ScrollViewController {
    
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    internal let continueButton = UIButton.createCommonBottomButton("common.continue")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.text = "common.reminder.sent".localized
        label.font = .futuraMedium(22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var animationView: AnimationView = {
        let view = AnimationView(name: "success")
        view.contentMode = .scaleAspectFit
        view.backgroundBehavior = .pauseAndRestore
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.height.width.equalTo(225)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
        }
        
        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(animationView.snp.bottom).offset(40)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135)
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(Util.heigherThanIphone6 ? 2 : 100)
        }
        view.bringSubviewToFront(scrollView)
        
        navigationController?.hideNavBar()
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        
        continueButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
}
