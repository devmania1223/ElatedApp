//
//  EmojiGoTimesUpPopup.swift
//  Elated
//
//  Created by Marlon on 9/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmojiGoTimesUpPopup: UIView {

    let didReset = PublishRelay<Void>()
    let didSkip = PublishRelay<Void>()
    let didSetting = PublishRelay<Void>()

    private let bgView: UIView = {
        let view = UIView()
        view.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(16)
        label.textColor = .jet
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "emojiGo.settings.timesUp".localized
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraLight(14)
        label.textColor = .jet
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "emojiGo.settings.timesUp.message".localized
        return label
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .elatedPrimaryPurple
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("emojiGo.settings.reset".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .elatedPrimaryPurple
        button.cornerRadius = 22.5
        button.titleLabel?.font = .futuraBook(14)
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("emojiGo.settings.pass".localized, for: .normal)
        button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        button.tintColor = .white
        button.cornerRadius = 22.5
        button.titleLabel?.font = .futuraBook(14)
        button.borderWidth = 0.25
        button.borderColor = .sonicSilver
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(33)
        }
        
        bgView.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16)
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(settingsButton)
            make.left.right.equalToSuperview().inset(55)
        }
        
        bgView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.left.right.equalToSuperview().inset(22)
        }
        
        bgView.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(45)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(45)
        }
        
        bgView.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(resetButton.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().inset(33)
            make.height.equalTo(45)
        }
        
    }
    
    private func bind() {
        
        resetButton.rx.tap.bind { [weak self] in
            self?.didReset.accept(())
        }.disposed(by: rx.disposeBag)
        
        skipButton.rx.tap.bind { [weak self] in
            self?.didSkip.accept(())
        }.disposed(by: rx.disposeBag)
        
        settingsButton.rx.tap.bind { [weak self] in
            self?.didSetting.accept(())
        }.disposed(by: rx.disposeBag)
        
    }


}

