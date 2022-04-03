//
//  SettingsAccountViewController+Bindings.swift
//  Elated
//
//  Created by Yiel Miranda on 3/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift

extension SettingsAccountViewController {
    func bindView() {
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.titleText.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.messageText.bind(to: messageLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.cancelButtonText.bind(to: cancelButton.rx.title(for: .normal)).disposed(by: disposeBag)
        
        viewModel.proceedButtonText.bind(to: proceedButton.rx.title(for: .normal)).disposed(by: disposeBag)
    }
    
    func bindEvents() {
        backButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.bind { [weak self] in
            self?.viewModel.didCancel()
        }.disposed(by: disposeBag)
        
        proceedButton.rx.tap.bind { [weak self] in
            self?.viewModel.didProceed()
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.userLogout)
            .subscribe(onNext: { [weak self] _ in
                UserDefaults.standard.clearUserData()
                Util.setRootViewController(LandingViewController())
                self?.viewModel.unregisterNotification()
            }).disposed(by: rx.disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] in
            self?.proceedToSuccessPage()
        }).disposed(by: disposeBag)
    }
}
