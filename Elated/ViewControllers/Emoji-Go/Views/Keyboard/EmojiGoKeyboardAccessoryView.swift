//
//  EmojiGoKeyboardAccessoryView.swift
//  Elated
//
//  Created by Marlon on 9/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa

class EmojiGoKeyboardAccessoryView: UIView {
    
    enum InputType {
        case emoji
        case text
    }
    
    var inputType = BehaviorRelay<InputType>(value: .emoji)
    var emojiLimit = BehaviorRelay<Int?>(value: nil)
    var didLimit = PublishRelay<Bool>()
    var didSendEmoji = PublishRelay<String>()
    var didSendText = PublishRelay<String>()

    lazy var emojiTextField = initTextField(false)
    lazy var normalTextField = initTextField(true)

    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-chat-send"), for: .normal)
        button.alpha = 0.6
        button.isUserInteractionEnabled = false
        return button
    }()
        
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 86))
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        
        backgroundColor = .white
        addSubview(emojiTextField)
        emojiTextField.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().inset(10)
        }
        
        addSubview(normalTextField)
        normalTextField.snp.makeConstraints { make in
            make.edges.equalTo(emojiTextField)
        }
        
        addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.left.equalTo(normalTextField.snp.right).offset(9)
            make.right.equalToSuperview().inset(16)
            make.height.width.equalTo(25)
            make.centerY.equalTo(normalTextField)
        }
        
    }
    
    private func bind() {
        inputType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.normalTextField.alpha = type == .text ? 1 : 0
            self.normalTextField.isUserInteractionEnabled = type == .text

            self.emojiTextField.alpha = type == .emoji ? 1 : 0
            self.emojiTextField.isUserInteractionEnabled = type == .emoji
        }).disposed(by: rx.disposeBag)
        
        sendButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            var chars = [Character]()
            for c in self.emojiTextField.text! {
                chars.append(c)
            }
            if self.inputType.value == .emoji {
                self.didSendEmoji.accept(String(chars))
            } else {
                self.didSendText.accept(self.normalTextField.text!)
            }
        }.disposed(by: rx.disposeBag)
    }
    
    private func initTextField(_ normal: Bool = false) -> UITextField {
        let view = normal ? UITextField() : EmojiTextField()
        view.layer.cornerRadius = 22.5
        view.backgroundColor = .alabasterApprox
        view.font = .futuraBook(12)
        view.textColor = .jet
        
        let spacerLeft = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 60))
        let spacerRight = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 60))
        
        view.leftViewMode = .always
        view.rightViewMode = .always
        view.leftView = spacerLeft
        view.rightView = spacerRight
        view.enablesReturnKeyAutomatically = false
        view.placeholder = "emojiGo.texfield.placeholder.answer".localized
        view.inputAccessoryView = nil
        view.autocorrectionType = .no
        view.returnKeyType = .next
        view.delegate = self
        view.shouldHideToolbarPlaceholder = true
        return view
    }
}

extension EmojiGoKeyboardAccessoryView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""

        if inputType.value == .emoji {
            //count limit first
            if let limit = emojiLimit.value {
                let newLength = updatedString.emojis.count
                didLimit.accept(newLength > limit)
                sendButton.alpha = newLength == limit ? 1 : 0.6
                sendButton.isUserInteractionEnabled = newLength == limit
            }
            
            //validate emoji
            for c in string {
                print("Current emoji: \(c)")
                if !c.isEmoji {
                    return false
                }
            }
        } else {
            sendButton.alpha = updatedString.count > 0 ? 1 : 0.6
            sendButton.isUserInteractionEnabled = updatedString.count > 0
        }
        return true
    }
    
}

class EmojiTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   // required for iOS 13
   override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
    
}
