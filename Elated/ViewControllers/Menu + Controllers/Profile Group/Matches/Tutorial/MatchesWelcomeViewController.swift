//
//  MatchesWelcomeViewController.swift
//  Elated
//
//  Created by Marlon on 5/19/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class MatchesWelcomeViewController: ScrollViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "menu.tabview.tab.welcome".localized
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "heart-popup")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "menu.tabview.tab.welcome.sub".localized
        label.textColor = .sonicSilver
        label.numberOfLines = 0
        label.font = .futuraBook(14)
        label.textAlignment = .center
        return label
    }()

    internal let continueButton = UIButton.createCommonBottomButton("common.continue")
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
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
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(40)
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
        
        continueButton.rx.tap.bind { [weak self] in
            
            let vc = MatchesHowItWorksViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self?.present(vc, animated: true, completion: nil)
            
        }.disposed(by: disposeBag)
        
    }

}
