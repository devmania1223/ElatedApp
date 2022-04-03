//
//  EmojiGoSettingsView.swift
//  Elated
//
//  Created by Marlon on 9/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmojiGoStoryShareSettingsPopup: UIView {

    let didBack = PublishRelay<Void>()
    let didChangeGame = PublishRelay<Void>()
    let didViewTutorial = PublishRelay<Void>()
    let didBlockUser = PublishRelay<Void>()
    let didEndGame = PublishRelay<Void>()

    let isFromTimesUp = BehaviorRelay<Bool>(value: false)
    
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
        label.text = "emojiGo.settings.menu.title".localized
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .tuftsBlue
        return button
    }()
    
    private lazy var changeGameButton = createButton(text: "emojiGo.settings.menu.button.changeGame")
    private lazy var viewTutorialButton = createButton(text: "emojiGo.settings.menu.button.viewTutorial")
    private lazy var blockUserButton = createButton(text: "emojiGo.settings.menu.button.blockUser")
    private lazy var endGameButton = createButton(text: "emojiGo.settings.menu.button.endGame")
    
    init(theme: UIColor = .tuftsBlue) {
        
        let keyWindow = UIApplication.shared.connectedScenes
                                    .filter({$0.activationState == .foregroundActive})
                                    .map({$0 as? UIWindowScene})
                                    .compactMap({$0})
                                    .first?.windows
                                    .filter({$0.isKeyWindow}).first
        
        super.init(frame: keyWindow!.frame)

        backButton.tintColor = theme
        changeGameButton.setTitleColor(theme, for: .normal)
        viewTutorialButton.setTitleColor(theme, for: .normal)
        blockUserButton.setTitleColor(theme, for: .normal)
        endGameButton.setTitleColor(theme, for: .normal)

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
        
        bgView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.left.right.equalToSuperview().inset(55)
        }
        
        bgView.addSubview(changeGameButton)
        changeGameButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(45)
        }
        
        bgView.addSubview(viewTutorialButton)
        viewTutorialButton.snp.makeConstraints { make in
            make.top.equalTo(changeGameButton.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(45)
        }
        
        bgView.addSubview(blockUserButton)
        blockUserButton.snp.makeConstraints { make in
            make.top.equalTo(viewTutorialButton.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(45)
        }
        
        bgView.addSubview(endGameButton)
        endGameButton.snp.makeConstraints { make in
            make.top.equalTo(blockUserButton.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().inset(33)
            make.height.equalTo(45)
        }
        
    }
    
    private func bind() {
        
        backButton.rx.tap.bind { [weak self] in
            self?.didBack.accept(())
        }.disposed(by: rx.disposeBag)
        
        changeGameButton.rx.tap.bind { [weak self] in
            self?.didChangeGame.accept(())
        }.disposed(by: rx.disposeBag)
        
        viewTutorialButton.rx.tap.bind { [weak self] in
            self?.didViewTutorial.accept(())
        }.disposed(by: rx.disposeBag)
        
        blockUserButton.rx.tap.bind { [weak self] in
            self?.didBlockUser.accept(())
        }.disposed(by: rx.disposeBag)
        
        endGameButton.rx.tap.bind { [weak self] in
            self?.didEndGame.accept(())
        }.disposed(by: rx.disposeBag)
        
    }

    private func createButton(text: String) -> UIButton {
        let button = UIButton()
        button.setTitle(text.localized, for: .normal)
        button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        button.tintColor = .white
        button.cornerRadius = 22.5
        button.titleLabel?.font = .futuraBook(14)
        button.borderWidth = 0.25
        button.borderColor = .sonicSilver
        return button
    }

}
