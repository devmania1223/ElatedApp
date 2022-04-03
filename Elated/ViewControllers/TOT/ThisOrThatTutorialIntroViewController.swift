//
//  ThisOrThatTutorialIntroViewController.swift
//  Elated
//
//  Created by Rey Felipe on 7/19/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//


import UIKit
import Lottie

class ThisOrThatTutorialIntroViewController: ScrollViewController {
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    internal let actionButton = UIButton.createCommonBottomButton("this.or.that.popup.button")

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "this.or.that.tutorial.title".localized
        label.textAlignment = .center
        return label
    }()
    
    private let touchImage: UIImageView  = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "tot-tutorial"))
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
            make.centerX.equalTo(touchImage.snp.centerX).offset(110)
            make.top.equalTo(touchImage.snp.top).offset(5)
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
            let vc = ThisOrThatWelcomePageViewController(skipHowToScreen: true)
            vc.modalPresentationStyle = .fullScreen
            self?.show(vc, sender: nil)
        }.disposed(by: disposeBag)
    }
}
