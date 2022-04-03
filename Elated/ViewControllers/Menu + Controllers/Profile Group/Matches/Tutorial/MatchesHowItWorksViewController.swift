//
//  MatchesHowItWorksViewController.swift
//  Elated
//
//  Created by Marlon on 5/19/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class MatchesHowItWorksViewController: ScrollViewController {
    
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    internal let continueButton = UIButton.createCommonBottomButton("common.continue")

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "menu.tabview.tab.howItWorks".localized
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.textAlignment = .center
        return label
    }()
    
    private let touchImage: UIImageView  = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "matches-tutorial"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "tap-gesture")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "menu.tabview.tab.howItWorks.sub".localized
        label.textColor = .sonicSilver
        label.numberOfLines = 0
        label.font = .futuraBook(14)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        contentView.addSubview(touchImage)
        touchImage.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.centerX.equalTo(touchImage.snp.centerX).offset(-45)
            make.top.equalTo(touchImage.snp.top).offset(5)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(touchImage.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
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
        
        continueButton.rx.tap.bind { [weak self] _ in
            
            UserDefaults.standard.setValue(true, forKey: UserDefaults.Key.isMatchesScreenViewFirstTime)
            
            let vc = MatchesLoadingViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self?.present(vc, animated: true, completion: nil)
        
        }.disposed(by: disposeBag)
        
    }

}
