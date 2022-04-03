//
//  ThisOrThatTutorialDoneViewController.swift
//  Elated
//
//  Created by John Lester Celis on 4/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class ThisOrThatTutorialDoneViewController: ScrollViewController {
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    internal let thisorthatImage = UIImageView(image: #imageLiteral(resourceName: "graphic_thisorthat"))
    internal let gotItButton = UIButton.createCommonBottomButton("common.gotit")

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "this.or.that.done.tutorial.title".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(14)
        label.text = "this.or.that.done.tutorial.body".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "tap-gesture")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    private var isOnboarding = false
    
    init(_ onboarding: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.isOnboarding = onboarding
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isOnboarding {
            UserDefaults.standard.showOnboardingTOT = true
        }
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
        
        contentView.addSubview(thisorthatImage)
        thisorthatImage.snp.makeConstraints { make in
            make.height.equalTo(164)
            make.width.equalTo(189)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.height.width.equalTo(190)
            make.centerX.equalToSuperview()
            make.top.equalTo(thisorthatImage.snp.top)
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(thisorthatImage.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(60)
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
        gotItButton.rx.tap.bind { [weak self] in
            guard let self = self else {  return }
            
            if self.isOnboarding {
                //Show the ToT Onboarding questions
                let vc = MenuTabBarViewController([.fromOnboarding])
                vc.selectedIndex = MenuTabBarViewController.MenuIndex.thisOrThat.rawValue
                let landingNav = UINavigationController(rootViewController: vc)
                Util.setRootViewController(landingNav)
                return
            }
            
            let landingNav = UINavigationController(rootViewController: HowToUseViewController())
            Util.setRootViewController(landingNav)
            
        }.disposed(by: disposeBag)
    }
}
