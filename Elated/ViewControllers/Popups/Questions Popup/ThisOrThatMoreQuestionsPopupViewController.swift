//
//  ThisOrThatMoreQuestionsPopupViewController.swift
//  Elated
//
//  Created by Rey Felipe on 8/11/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class ThisOrThatMoreQuestionsPopupViewController: ScrollViewController {
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    private let answerMoreButton = UIButton.createCommonBottomButton("this.or.that.answer.more".localized)
    private let matchButton: UIButton = {
        let button = UIButton.createButtonWithShadow("this.or.that.match.me".localized, with: true)
        button.borderWidth = 0.25
        button.borderColor = .silver
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "this.or.that.more.title".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(14)
        label.text = "this.or.that.more.body".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "success")
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
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.height.width.equalTo(175)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(60)
        }
        
        contentView.addSubview(answerMoreButton)
        answerMoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(bodyLabel.snp.bottom).offset(30)
        }
        
        contentView.addSubview(matchButton)
        matchButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(answerMoreButton.snp.bottom).offset(20)
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
        
        answerMoreButton.rx.tap.bind {
            let vc = ThisOrThatOrderedChoicesViewController()
            vc.modalPresentationStyle = .fullScreen
            self.show(vc, sender: nil)
            
//            let vc = MenuTabBarViewController()
//            vc.selectedIndex = MenuTabBarViewController.MenuIndex.thisOrThat.rawValue
//            //vc.onboarding = true
//            let landingNav = UINavigationController(rootViewController: vc)
//            Util.setRootViewController(landingNav)
        }.disposed(by: disposeBag)
        
        matchButton.rx.tap.bind { [weak self] _ in
            let vc = MatchesWelcomeViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self?.present(vc, animated: true, completion: nil)
        }.disposed(by: disposeBag)

    }
}
