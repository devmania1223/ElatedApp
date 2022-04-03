//
//  MatchesMoreQuestionsPopupViewController.swift
//  Elated
//
//  Created by Rey Felipe on 8/31/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class MatchesMoreQuestionsPopupViewController: ScrollViewController {
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    internal let touchImage = UIImageView(image: #imageLiteral(resourceName: "graphic_thisorthat"))
    internal let actionButton = UIButton.createCommonBottomButton("common.continue".localized)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "matches.more.questions.title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(14)
        label.text = "tooltip.tot.instruction.reminder".localized
        label.numberOfLines = 0
        label.textAlignment = .center
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
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(50)
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
        
        navigationController?.hideNavBar()
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        
        actionButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            let vc = ThisOrThatOrderedChoicesViewController()
            vc.modalPresentationStyle = .fullScreen
            self.show(vc, sender: nil)

//            let vc = 
//            vc.modalPresentationStyle = .fullScreen
//            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
    }
}

