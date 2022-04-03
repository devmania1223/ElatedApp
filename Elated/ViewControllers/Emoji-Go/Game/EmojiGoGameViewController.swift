//
//  EmojiGoGameViewController.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON

class EmojiGoGameViewController: BaseViewController {

    let viewModel = EmojiGoGameViewModel()
    
    internal var chatTableView = EmojiGoChatTableView()
    
    internal var questionView: EmojiQuestionView?
    
    internal lazy var timer = Timer.scheduledTimer(timeInterval: 1,
                                                  target: self,
                                                  selector: #selector(countDown),
                                                  userInfo: nil,
                                                  repeats: true)
    
    internal let bgImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "bg-pulse"))
    
    private let titleImageView = UIImageView(image: #imageLiteral(resourceName: "icon_emoji_text"))
    
    internal let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    internal let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white"), for: .normal)
        return button
    }()
    
    internal let goButton: UIButton = {
        let button = UIButton()
        button.setTitle("common.go!".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 25
        button.titleLabel?.font = .comfortaaBold(14)
        button.layer.applySketchShadow(color: .black,
                                       alpha: 0.15,
                                       x: 0,
                                       y: 3,
                                       blur: 18,
                                       spread: 0)
        button.clipsToBounds = true
        return button
    }()
    
    internal let passButton: UIButton = {
        let button = UIButton()
        button.setTitle("emojiGo.settings.pass".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 25
        button.titleLabel?.font = .comfortaaBold(14)
        button.layer.applySketchShadow(color: .black,
                                       alpha: 0.15,
                                       x: 0,
                                       y: 3,
                                       blur: 18,
                                       spread: 0)
        button.clipsToBounds = true
        return button
    }()
    
    internal lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [goButton, passButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    internal let circleOuter: UIView = {
        let view = UIView()
        view.backgroundColor = .goGradient_FFAE2E
        view.layer.cornerRadius = 40
        return view
    }()
    
    internal let circleInner: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    internal let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkOrchid
        label.font = .futuraMedium(24)
        label.textAlignment = .center
        return label
    }()
    
    internal let turnLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .futuraMedium(20)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    internal let keyWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first

    internal lazy var timesUpView = EmojiGoTimesUpPopup(frame: keyWindow!.frame)
    internal lazy var settingsView = EmojiGoStoryShareSettingsPopup()
    internal lazy var skipView = EmojiGoSkipPopup(frame: keyWindow!.frame)
    
    internal let textInputView = EmojiGoKeyboardAccessoryView()
    
    internal lazy var emojiCountBubble: AlertBubble = {
        let alert = AlertBubble(.bottomLeft,
                                text: "emojiGo.emoji.limit".localized,
                                color: .white,
                                textColor: .elatedPrimaryPurple)
        alert.label.font = .comfortaaBold(12)
        alert.label.paddingTop = 20;
        alert.label.paddingBottom = 20;
        alert.label.paddingLeft = 20;
        alert.label.paddingRight = 20;
        alert.isHidden = true
        return alert
    }()
    
    init(_ detail: EmojiGoGameDetail) {
        super.init(nibName: nil, bundle: nil)
          viewModel.detail.accept(detail)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        
        timer.fire()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //apply gradient after layout
        goButton.gradientBackground(from: .maximumYellowRed,
                                    to: .goGradient_FFAE2E,
                                    direction: .bottomToTop)
        
        passButton.gradientBackground(from: .lavanderFloral,
                                      to: .darkOrchid,
                                      direction: .topToBottom)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        timer.invalidate()
        viewModel.turnTimer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
        
        view.addSubview(textInputView)
        textInputView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(80)
        }
        
        view.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(17)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.centerY.equalTo(titleImageView)
            make.width.height.equalTo(25)
        }
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleImageView)
            make.right.equalTo(-19)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(circleOuter)
        circleOuter.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(23)
            make.centerX.equalTo(titleImageView)
            make.width.height.equalTo(80)
        }
        
        circleOuter.addSubview(circleInner)
        circleInner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        circleInner.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        view.addSubview(turnLabel)
        turnLabel.snp.makeConstraints { make in
            make.center.equalTo(circleOuter)
        }
        
        view.addSubview(chatTableView)
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(circleOuter.snp.bottom).offset(17)
            make.left.right.equalToSuperview().inset(30)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(chatTableView.snp.bottom).offset(16)
            make.centerX.equalTo(chatTableView)
            make.bottom.equalTo(textInputView.snp.top).offset(-36)
        }
        
        goButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(148)
        }
        
        passButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(148)
        }
        
        view.addSubview(emojiCountBubble)
        emojiCountBubble.snp.makeConstraints { make in
            make.bottom.equalTo(textInputView.snp.top)
            make.left.equalToSuperview().inset(22)
        }
        
    }
    
    override func bind() {
        bindView()
        bindEvents()
    }
    
    @objc internal func countDown() {
        var time = viewModel.currentTime.value
        time -= 1
        if time == 0 {
            self.timer.invalidate()
        }
        
        viewModel.currentTime.accept(time)
    }
    
    internal func resetTimer() {
        timer.invalidate()
        viewModel.currentTime.accept(15)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                      target: self,
                                      selector: #selector(self.countDown),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    @objc internal func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.textInputView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(keyboardHeight)
                }
                
                self.buttonStackView.isHidden = true
                self.buttonStackView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.textInputView.snp.top).inset(62)
                }
    
                self.backButton.isHidden = true
                self.settingsButton.isHidden = true
                self.titleImageView.isHidden = true
                
                self.titleImageView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                }
                
                self.chatTableView.snp.updateConstraints { make in
                    make.top.equalTo(self.circleOuter.snp.bottom).offset(8)
                }
                
                self.circleOuter.snp.updateConstraints { make in
                    make.top.equalTo(self.titleImageView.snp.bottom).inset(25)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.chatTableView.scrollToBottom()
            })
            
        }
    }
    
    @objc internal func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.textInputView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(80)
            }
            
            self.buttonStackView.isHidden = !MemCached.shared.isSelf(id: self.viewModel.detail.value?.currentPlayerTurn)
            self.buttonStackView.snp.updateConstraints { make in
                make.bottom.equalTo(self.textInputView.snp.top).offset(-36)
            }
            
            self.backButton.isHidden = false
            self.settingsButton.isHidden = false
            self.titleImageView.isHidden = false
            
            self.titleImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(17)
            }
            
            self.chatTableView.snp.updateConstraints { make in
                make.top.equalTo(self.circleOuter.snp.bottom).offset(17)
            }
            
            self.circleOuter.snp.updateConstraints { make in
                make.top.equalTo(self.titleImageView.snp.bottom).offset(23)
            }
        }
    }
    
}
