//
//  SetPasswordViewController.swift
//  Elated
//
//  Created by Marlon on 7/12/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class SetPasswordViewController: BaseViewController {

    private let viewModel = SetPasswordViewModel()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "forgotpassword.set.new.password".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var passwordTextField: UITextField = createTextField(leftImage: #imageLiteral(resourceName: "icon-lock"),
                                                                      rightImage: nil,
                                                                      placeholder: "signup.password.placeholder")
    
    private lazy var confirmPasswordTextField: UITextField = createTextField(leftImage: #imageLiteral(resourceName: "icon-lock"),
                                                                             rightImage: nil,
                                                                             placeholder: "signup.confirmPassword.placeholder")
    
    private let incorrectPasswordBubble: AlertBubble = {
        let passwordRules = [
            "signup.validation.password.rule.1".localized,
            "signup.validation.password.rule.2".localized,
            "signup.validation.password.rule.3".localized
        ]
        let attributedText = String.bulletList(stringList: passwordRules, font: .futuraBook(12))
        let view = AlertBubble(.topCenter,
                               attributedText: attributedText,
                               color: .elatedPrimaryPurple)
        return view
    }()
    
    private let incorrectConfirmPasswordBubble: AlertBubble = {
        let view = AlertBubble(.topCenter,
                               text: "signup.validation.password.match.msg".localized,
                               color: .danger)
        return view
    }()
    
    private let resetPasswordButton = UIButton.createCommonBottomButton("forgotpassword.set.button")

    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    init(uid: String, token: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.uid.accept(uid)
        viewModel.token.accept(token)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initSubviews() {
        super.initSubviews()
                
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(105)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(55)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(60)
        }
        
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(22)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(60)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
        }
        
        view.addSubview(incorrectPasswordBubble)
        incorrectPasswordBubble.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(1)
            make.left.right.equalTo(passwordTextField)
        }
        
        view.addSubview(incorrectConfirmPasswordBubble)
        incorrectConfirmPasswordBubble.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(1)
            make.centerX.equalTo(confirmPasswordTextField)
        }

    }
    
    override func bind() {
        super.bind()
        
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        let passwordLeftImage = passwordTextField.leftView?.viewWithTag(1000) as! UIImageView
        let confirmPasswordLeftImage = confirmPasswordTextField.leftView?.viewWithTag(1000) as! UIImageView

        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        confirmPasswordTextField.rx.text.orEmpty.bind(to: viewModel.confirmPassword).disposed(by: disposeBag)

        viewModel.passwordBorderWidth.bind(to: passwordTextField.layer.rx.borderWidth).disposed(by: disposeBag)
        viewModel.confirmPasswordBorderWidth.bind(to: confirmPasswordTextField.layer.rx.borderWidth).disposed(by: disposeBag)

        viewModel.passwordTint.subscribe(onNext: { [weak self] tint in
            self?.passwordTextField.layer.borderColor = tint.cgColor
            passwordLeftImage.tintColor = tint
        }).disposed(by: disposeBag)
        
        viewModel.confirmPasswordTint.subscribe(onNext: { [weak self] tint in
            self?.confirmPasswordTextField.textColor = tint
            self?.confirmPasswordTextField.layer.borderColor = tint.cgColor
            confirmPasswordLeftImage.tintColor = tint
        }).disposed(by: disposeBag)
        
        //error bubbles
        viewModel.hidePasswordBubble
            .bind(to: incorrectPasswordBubble.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.hideConfirmPasswordBubble
            .bind(to: incorrectConfirmPasswordBubble.rx.isHidden)
            .disposed(by: disposeBag)
        
        //sign up button
        viewModel.allowSetPassword.subscribe(onNext: { [weak self] allow in
            self?.resetPasswordButton.isUserInteractionEnabled = allow
            self?.resetPasswordButton.alpha = allow ? 1 : 0.6
        }).disposed(by: disposeBag)

        resetPasswordButton.rx.tap.bind { [weak self] in
            self?.viewModel.setPassword()
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] in
            self?.presentAlert(title: "common.success".localized,
                               message: "resetPassword.success.message".localized,
                               buttonTitles: ["signin.signin".localized],
                               highlightedButtonIndex: 0,
                               completion: { index in
                                let nav = UINavigationController(rootViewController: SigninViewController.xib())
                                Util.setRootViewController(nav, animated: true, completion: nil)
            })
        }).disposed(by: disposeBag)
        
    }
    
    
    private func createTextField(leftImage: UIImage,
                                 rightImage: UIImage?,
                                 placeholder: String) -> UITextField {
        
        let field = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 50))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 50))

        let leftImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 19, height: 50))
        leftImageView.tag = 1000
        let rightImageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 18, height: 50))
        rightImageView.tag = 1001
        leftImageView.image = leftImage.withRenderingMode(.alwaysTemplate)
        rightImageView.image = rightImage?.withRenderingMode(.alwaysTemplate)
        
        leftImageView.contentMode = .scaleAspectFit
        rightImageView.contentMode = .scaleAspectFit

        leftView.addSubview(leftImageView)
        rightView.addSubview(rightImageView)
        
        field.isSecureTextEntry = true
        field.backgroundColor = .alabasterSolid
        field.leftView = leftView
        field.rightView = rightView
        field.font = .futuraBook(14)
        field.autocapitalizationType = .none
        field.leftViewMode = .always
        field.rightViewMode = .always
        field.layer.cornerRadius = 30
        field.layer.borderColor = UIColor.elatedPrimaryPurple.cgColor
        field.attributedPlaceholder = NSAttributedString(string: placeholder.localized,
                                                         attributes: [NSAttributedString.Key.foregroundColor:
                                                                      UIColor.silver])
        return field
    }
    
}
