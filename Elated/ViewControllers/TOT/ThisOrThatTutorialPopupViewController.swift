//
//  ThisOrThatTutorialPopupViewController.swift
//  Elated
//
//  Created by John Lester Celis on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class ThisOrThatTutorialPopupViewController: ScrollViewController {
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    internal let touchImage = UIImageView(image: #imageLiteral(resourceName: "graphic_thisorthat"))
    internal let actionButton = UIButton.createCommonBottomButton("this.or.that.popup.button")

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "this.or.that.popup.title".localized
        label.textAlignment = .center
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(14)
        label.text = "this.or.that.popup.body".localized
        label.numberOfLines = 0
        label.textAlignment = .left
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
            make.height.equalTo(138)
            make.width.equalTo(159)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.height.width.equalTo(175)
            make.centerX.equalToSuperview().offset(5)
            make.top.equalTo(touchImage.snp.top).offset(-10)
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(touchImage.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        contentView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
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
        
        actionButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let vc = ThisOrThatTutorialAnimationViewController(self.isOnboarding)
            vc.modalPresentationStyle = .fullScreen
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
    }
}
