//
//  SignupViewController+Bindings.swift
//  Elated
//
//  Created by Marlon on 2021/2/28.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension SignupViewController {

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
        let passwordLeftImage = passwordTextField.leftView?.viewWithTag(1000) as! UIImageView
        let confirmPasswordLeftImage = confirmPasswordTextField.leftView?.viewWithTag(1000) as! UIImageView

        emailTextField.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        confirmEmailTextField.rx.text.orEmpty.bind(to: viewModel.confirmEmail).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        confirmPasswordTextField.rx.text.orEmpty.bind(to: viewModel.confirmPassword).disposed(by: disposeBag)

        viewModel.emailBorderWidth.bind(to: emailTextField.layer.rx.borderWidth).disposed(by: disposeBag)
        viewModel.confirmEmailBorderWidth.bind(to: confirmEmailTextField.layer.rx.borderWidth).disposed(by: disposeBag)
        viewModel.passwordBorderWidth.bind(to: passwordTextField.layer.rx.borderWidth).disposed(by: disposeBag)
        viewModel.confirmPasswordBorderWidth.bind(to: confirmPasswordTextField.layer.rx.borderWidth).disposed(by: disposeBag)

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
        viewModel.hideEmailBubble
            .bind(to: emailInUseBubble.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.hidePasswordBubble
            .bind(to: incorrectPasswordBubble.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.hideConfirmPasswordBubble
            .bind(to: incorrectConfirmPasswordBubble.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.hideConfirmEmaildBubble.bind(to: incorrectConfirmEmailBubble.rx.isHidden)
            .disposed(by: disposeBag)
        
        //sign up button
        viewModel.allowSignUp.subscribe(onNext: { [weak self] allow in
            self?.joinButton.isUserInteractionEnabled = allow
            self?.joinButton.alpha = allow ? 1 : 0.6
        }).disposed(by: disposeBag)
        
    }
    
    func bindEvents() {
        
        joinButton.rx.tap.bind { [weak self] in
            self?.viewModel.signup()
        }.disposed(by: disposeBag)
        
        viewModel.registered.subscribe(onNext: { [weak self] in
            if let email = self?.viewModel.email.value {
                let vc = SignupConfirmationViewController(email)
                self?.show(vc, sender: self)
            }
        }).disposed(by: disposeBag)
        
    }
    
}
