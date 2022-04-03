//
//  StoryShareGameViewController.swift
//  Elated
//
//  Created by Marlon on 10/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class StoryShareGameViewController: BaseViewController {

    internal let viewModel = StoryShareGameViewModel()
    
    internal let dictionaryView: BashoDictionaryView = {
        let view = BashoDictionaryView()
        view.bgView.backgroundColor = .white
        return view
    }()
    
    internal lazy var alertBubble: StoryShareTurnBubble = {
        let alert = StoryShareTurnBubble(dismissable: true)
        return alert
    }()

    internal let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .chestnut
        return button
    }()
    
    internal let periodButton: UIButton = {
        let button = UIButton()
        button.setTitle("storyshare.period".localized, for: .normal)
        button.setTitleColor(.umber, for: .normal)
        button.titleLabel?.font = .courierPrimeRegular(14)
        button.cornerRadius = 25
        button.backgroundColor = .white
        return button
    }()
    
    internal let enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("storyshare.enter".localized, for: .normal)
        button.setTitleColor(.umber, for: .normal)
        button.titleLabel?.font = .courierPrimeRegular(14)
        button.cornerRadius = 25
        button.backgroundColor = .white
        return button
    }()
    
    internal lazy var invisibleTextField: UITextField = {
        let textField = UITextField()
        //textField.isUserInteractionEnabled = false
        textField.alpha = 0
        textField.autocorrectionType = .no
        textField.enablesReturnKeyAutomatically = false
        textField.delegate = self
        return textField
    }()
    
    private let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "background-storyshare"))
    
    private let typeWriterImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "asset-storyshare-typewriter-menu"))
        imageView.contentMode = .top
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(20)
        label.text = "storyshare.title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal let storyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .courierPrimeBold(12)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.spellCheckingType = .yes
        return textView
    }()
    
    internal let colorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .umber
        label.font = .courierPrimeRegular(12)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let reminderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .umber
        label.font = .courierPrimeRegular(12)
        label.text = "storyshare.phrase.reminder".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .chestnut
        return button
    }()
    
    internal let keyWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first
    
    internal lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [periodButton, enterButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    internal lazy var settingsView = EmojiGoStoryShareSettingsPopup(theme: .chestnut)
    
    init(_ detail: StoryShareGameDetail, isFromLineView: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        viewModel.detail.accept(detail)
        viewModel.isFromLineView = isFromLineView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavBar()
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
        storyTextView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        invisibleTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        invisibleTextField.resignFirstResponder()
    }
    
    override func initSubviews() {
        super.initSubviews()
            
        //at the back
        view.addSubview(invisibleTextField)

        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
    
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(25)
        }
        
        view.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(reminderLabel)
        reminderLabel.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(alertBubble)
        alertBubble.snp.makeConstraints { make in
            make.top.equalTo(reminderLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(typeWriterImage)
        typeWriterImage.snp.makeConstraints { make in
            make.top.equalTo(alertBubble.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        view.addSubview(storyTextView)
        storyTextView.snp.makeConstraints { make in
            make.top.equalTo(typeWriterImage).inset(20)
            make.left.right.equalTo(typeWriterImage).inset(UIScreen.main.bounds.width * 0.15)
            make.bottom.equalTo(typeWriterImage.snp.centerY).offset(-57)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        periodButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        enterButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
            
        view.addSubview(dictionaryView)
        dictionaryView.isHidden = true
        dictionaryView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIDevice.current.hasTopNotch ? 250 : 175)
        }
        
    }
    
    override func bind() {
        bindView()
        bindEvents()
    }
    
    @objc internal func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.alertBubble.isHidden = true

                self.buttonStackView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(keyboardHeight + 12)
                }
            }
            
        }
    }
    
    @objc internal func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.alertBubble.isHidden = false
            
            self.buttonStackView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(30)
            }
        }
    }
    
    internal func manageDictionary(_ show: Bool, definition: BashoWordDefinition?) {
        self.dictionaryView.definition.accept(definition)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.dictionaryView.snp.updateConstraints { make in
                make.height.equalTo(show ? (UIDevice.current.hasTopNotch ? 250 : 175) : 0)
            }
        } completion: { [weak self] _ in
            self?.dictionaryView.isHidden = !show
        }
        self.view.layoutIfNeeded()
    }
    
    @objc private final func tapOnTextView(_ tapGesture: UITapGestureRecognizer){
        if MemCached.shared.isSelf(id: viewModel.detail.value?.currentPlayerTurn) {
            //make sure this is always active
            self.invisibleTextField.becomeFirstResponder()
        }
        let point = tapGesture.location(in: storyTextView)
        if let detectedWord = getWordAtPosition(point) {
              self.viewModel.getDefinition(detectedWord)
        }
    }
    
    private final func getWordAtPosition(_ point: CGPoint) -> String? {
        if let textPosition = storyTextView.closestPosition(to: point) {
            if let range = storyTextView.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: UITextDirection(rawValue: 1)) {
                return storyTextView.text(in: range)
            }
        }
        return nil
    }
    
}


extension StoryShareGameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
}

