//
//  SignupViewController.swift
//  Elated
//
//  Created by Marlon on 2021/2/27.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SignupViewController: ScrollViewController {
    
    internal let viewModel = SignupViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "signup.title".localized
        return label
    }()

    internal lazy var emailTextField = createTextField(false,
                                                      leftImage: #imageLiteral(resourceName: "icon-email"),
                                                      rightImage: nil,
                                                      placeholder: "signup.email.placeholder")
    
    internal lazy var confirmEmailTextField = createTextField(false,
                                                             leftImage: #imageLiteral(resourceName: "icon-email"),
                                                             rightImage: #imageLiteral(resourceName: "check"),
                                                             placeholder: "signup.confirmEmail.placeholder")
    
    internal lazy var passwordTextField: UITextField = createTextField(true,
                                                                      leftImage: #imageLiteral(resourceName: "icon-lock"),
                                                                      rightImage: nil,
                                                                      placeholder: "signup.password.placeholder")
    
    internal lazy var confirmPasswordTextField: UITextField = createTextField(true,
                                                                             leftImage: #imageLiteral(resourceName: "icon-lock"),
                                                                             rightImage: nil,
                                                                             placeholder: "signup.confirmPassword.placeholder")
    
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    internal let emailInUseBubble: AlertBubble = {
        let message = LanguageManager.shared.errorMessage(for: 100003)
        let view = AlertBubble(.topCenter,
                               text: message,
                               color: .danger)
        return view
    }()
    
    internal let incorrectPasswordBubble: AlertBubble = {
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
    
    internal let incorrectConfirmPasswordBubble: AlertBubble = {
        let view = AlertBubble(.topCenter,
                               text: "signup.validation.password.match.msg".localized,
                               color: .danger)
        return view
    }()
    
    internal let incorrectConfirmEmailBubble: AlertBubble = {
        let view = AlertBubble(.topCenter,
                               text: "signup.validation.email.match.msg".localized,
                               color: .danger)
        return view
    }()
    
    internal let joinButton = UIButton.createCommonBottomButton("signup.createAccount")
    
    internal let checkBox: CheckBox = {
        let checkBox = CheckBox("signup.updates".localized)
        return checkBox
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "splash.signin".localized,
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(signInTap))
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(55)
            make.height.equalTo(60)
            make.left.right.equalToSuperview().inset(33)
        }
        
        contentView.addSubview(confirmEmailTextField)
        confirmEmailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(19)
            make.height.equalTo(60)
            make.left.right.equalTo(emailTextField)
        }
        
        contentView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmEmailTextField.snp.bottom).offset(19)
            make.height.equalTo(60)
            make.left.right.equalTo(confirmEmailTextField)
        }
        
        contentView.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(19)
            make.height.equalTo(60)
            make.left.right.equalTo(passwordTextField)
        }
        
        contentView.addSubview(checkBox)
        checkBox.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(13)
            make.centerX.equalTo(confirmPasswordTextField)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        contentView.addSubview(emailInUseBubble)
        emailInUseBubble.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(1)
            make.centerX.equalTo(emailTextField)
        }
        
        contentView.addSubview(incorrectPasswordBubble)
        incorrectPasswordBubble.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(1)
            make.left.right.equalTo(passwordTextField)
        }
        
        contentView.addSubview(incorrectConfirmPasswordBubble)
        incorrectConfirmPasswordBubble.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(1)
            make.centerX.equalTo(confirmPasswordTextField)
        }
        
        contentView.addSubview(incorrectConfirmEmailBubble)
        incorrectConfirmEmailBubble.snp.makeConstraints { make in
            make.top.equalTo(confirmEmailTextField.snp.bottom).offset(1)
            make.centerX.equalTo(confirmEmailTextField)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(joinButton)
        joinButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
        }
        
        scrollView.snp.remakeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bottomBackground.snp.top)
        })
        
    }
    
    override func bind() {
        super.bind()
        bindView()
        bindEvents()
    }
    
    @objc private func signInTap() {
        navigationController?.pushViewController(SigninViewController.xib(), animated: true)
    }
    
    private func createTextField(_ isSecure: Bool,
                                 leftImage: UIImage,
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
        
        field.backgroundColor = .alabasterSolid
        field.leftView = leftView
        field.rightView = rightView
        field.isSecureTextEntry = isSecure
        field.keyboardType = isSecure ? .default : .emailAddress
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
