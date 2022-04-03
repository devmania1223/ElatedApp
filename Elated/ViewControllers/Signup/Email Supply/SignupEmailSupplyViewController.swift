//
//  SignupEmailSupplyViewController.swift
//  Elated
//
//  Created by Marlon on 6/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SignupEmailSupplyViewController: BaseViewController {
    
    internal let viewModel = SignupEmailSupplyViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "signup.title.email".localized
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
    
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    internal let joinButton = UIButton.createCommonBottomButton("signup.createAccount")

    
    init(type: ThirdPartyAuthType, socialMediaID: String, token: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.socialMediaID.accept(socialMediaID)
        viewModel.type.accept(type)
        viewModel.token.accept(token)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(84)
            make.height.equalTo(60)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(confirmEmailTextField)
        confirmEmailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(19)
            make.height.equalTo(60)
            make.left.right.equalTo(emailTextField)
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
    
    func bindView() {
        
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        //view bindings
        let emailLeftImage = emailTextField.leftView?.viewWithTag(1000) as! UIImageView
        let confirmEmailLeftImage = confirmEmailTextField.leftView?.viewWithTag(1000) as! UIImageView
        let confirmEmailRightImage = confirmEmailTextField.rightView?.viewWithTag(1001) as! UIImageView

        emailTextField.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        confirmEmailTextField.rx.text.orEmpty.bind(to: viewModel.confirmEmail).disposed(by: disposeBag)

        viewModel.emailBorderWidth.bind(to: emailTextField.layer.rx.borderWidth).disposed(by: disposeBag)
        viewModel.confirmEmailBorderWidth.bind(to: confirmEmailTextField.layer.rx.borderWidth).disposed(by: disposeBag)

        viewModel.emailTint.subscribe(onNext: { [weak self] tint in
            self?.emailTextField.textColor = tint
            self?.emailTextField.layer.borderColor = tint.cgColor
            emailLeftImage.tintColor = tint
        }).disposed(by: disposeBag)
        
        viewModel.confirmEmailTint.subscribe(onNext: { [weak self] tint in
            self?.confirmEmailTextField.textColor = tint
            self?.confirmEmailTextField.layer.borderColor = tint.cgColor
            confirmEmailLeftImage.tintColor = tint
        }).disposed(by: disposeBag)
        
        viewModel.confirmEmailValid.subscribe(onNext: { valid in
            confirmEmailRightImage.image = (valid ?? true ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "icon-close-circle-small")).withRenderingMode(.alwaysTemplate)
            confirmEmailRightImage.isHidden = valid == nil
            confirmEmailRightImage.tintColor = valid ?? true ? .greenCheckColor : .danger
        }).disposed(by: disposeBag)
        
        viewModel.allowSignUp.subscribe(onNext: { [weak self] allow in
            self?.joinButton.isUserInteractionEnabled = allow
            self?.joinButton.alpha = allow ? 1 : 0.6
        }).disposed(by: disposeBag)
        
    }
    
    func bindEvents() {
        
        joinButton.rx.tap.bind { [weak self] in
            self?.viewModel.register()
        }.disposed(by: disposeBag)
        
        viewModel.registered.subscribe(onNext: { [weak self] in
            if let email = self?.viewModel.email.value {
                let vc = SignupConfirmationViewController(email)
                self?.show(vc, sender: self)
            }
        }).disposed(by: disposeBag)
        
    }

}
