//
//  CreateProfileSuccessViewController.swift
//  Elated
//
//  Created by Rey Felipe on 10/31/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

import UIKit
import Lottie

class CreateProfileSuccessViewController: ScrollViewController {
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    internal let gotItButton = UIButton.createCommonBottomButton("common.gotit")

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "createProfile.success.title".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(14)
        label.text = "createProfile.success.message".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "thumbs-up")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBar(.elatedPrimaryPurple,
                                font: .futuraMedium(20),
                                tintColor: .elatedPrimaryPurple,
                                backgroundColor: .white,
                                backgroundImage: nil,
                                addBackButton: true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(250)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(50)
        }
        
        contentView.addSubview(gotItButton)
        gotItButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(173)
            make.top.equalTo(bodyLabel.snp.bottom).offset(30)
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

        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        gotItButton.rx.tap.bind { _ in
            // Show QR Code
            let landingNav = UINavigationController(rootViewController: SparkFlirtScanQRCodeOptionsViewController(true))
            landingNav.modalPresentationStyle = .fullScreen
            landingNav.modalTransitionStyle = .crossDissolve
            Util.setRootViewController(landingNav)
        }.disposed(by: disposeBag)
    }
}
