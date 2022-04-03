//
//  MobileOTPViewController.swift
//  Elated
//
//  Created by Marlon on 5/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import PhoneNumberKit

class MobileOTPViewController: BaseViewController {
    
    private let viewModel = MobileOTPViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "mobile.otp.title".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textColor = .eerieBlack
        label.textAlignment = .center
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "mobile.otp.subTitle".localized
        label.font = .futuraMedium(16)
        label.numberOfLines = 0
        label.textColor = .sonicSilver
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let numberTextField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField()
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        textField.withDefaultPickerUI = true
        return textField
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "mobile.otp.bottomTitle".localized
        label.font = .futuraBook(16)
        label.numberOfLines = 0
        label.textColor = .sonicSilver
        label.textAlignment = .center
        return label
    }()
    
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    internal let submitButton = UIButton.createCommonBottomButton("common.submit")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["US", "CA", "MX", "AU", "GB", "DE", "CN", "PH"]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "common.skip".localized,
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(skip))
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(titleLabel)
        }
        
        let tfView = UIView()
        tfView.borderWidth = 0.25
        tfView.borderColor = .silver
        tfView.cornerRadius = 30
        tfView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        tfView.addSubview(numberTextField)
        numberTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        let stackView = UIStackView(arrangedSubviews: [tfView, bottomLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalTo(titleLabel)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        submitButton.isUserInteractionEnabled = self.numberTextField.isValidNumber
        submitButton.alpha = self.numberTextField.isValidNumber ? 1 : 0.6
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
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
        
        viewModel.success.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.show(MobileOTPConfirmViewController(self.numberTextField.text ?? ""), sender: nil)
        }).disposed(by: disposeBag)
        
        numberTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.submitButton.isUserInteractionEnabled = self.numberTextField.isValidNumber
            self.submitButton.alpha = self.numberTextField.isValidNumber ? 1 : 0.6
            if self.numberTextField.isValidNumber {
                self.viewModel.phoneNumber.accept(self.numberTextField.text!)
            } else {
                self.viewModel.phoneNumber.accept(nil)
            }
        }).disposed(by: disposeBag)
        
        self.submitButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendOTP()
        }.disposed(by: disposeBag)
        
    }
    
    @objc private func skip() {
        // controller
        let landingNav = UINavigationController(rootViewController: MenuTabBarViewController())
        landingNav.modalPresentationStyle = .fullScreen
        Util.setRootViewController(landingNav)
    }

}

