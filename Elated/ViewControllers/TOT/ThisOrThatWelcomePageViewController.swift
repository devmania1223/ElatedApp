//
//  ThisOrThatWelcomePageViewController.swift
//  Elated
//
//  Created by John Lester Celis on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class ThisOrThatWelcomePageViewController: ScrollViewController {
    
    var isAfterOnboarding = false
    private var skipHowToScreen = false
    private var isOnboarding = false
    
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    internal let continueButton = UIButton.createCommonBottomButton("common.continue")

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "this.or.that.welcome.title".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "floating-yingyang")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraMedium(14)
        label.text = "this.or.that.welcome.body".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(skipHowToScreen: Bool = false, onboarding: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.skipHowToScreen = skipHowToScreen
        self.isOnboarding = onboarding
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            make.height.width.equalTo(118)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
        }
    
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(61)
        }
        
        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
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
        
        navigationController?.hideNavBar()
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        continueButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            if self.skipHowToScreen {
                let vc = ThisOrThatTutorialAnimationViewController(self.isOnboarding)
                vc.modalPresentationStyle = .fullScreen
                self.show(vc, sender: nil)
            } else {
                let vc = ThisOrThatTutorialPopupViewController(self.isOnboarding)
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
}
