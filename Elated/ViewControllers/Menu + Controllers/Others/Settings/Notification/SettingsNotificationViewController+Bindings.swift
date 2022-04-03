//
//  SettingsNotificationViewController+Bindings.swift
//  Elated
//
//  Created by Yiel Miranda on 3/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift

extension SettingsNotificationViewController {
    func bindView() {
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
    }
    
    func bindEvents() {
        hourButton.rx.tap.map { .forAnHour }.bind(to: viewModel.notificationFrequency).disposed(by: disposeBag)
        eveningButton.rx.tap.map { .untilThisEvening }.bind(to: viewModel.notificationFrequency).disposed(by: disposeBag)
        morningButton.rx.tap.map { .untilMorning }.bind(to: viewModel.notificationFrequency).disposed(by: disposeBag)
        weekButton.rx.tap.map { .forAWeek }.bind(to: viewModel.notificationFrequency).disposed(by: disposeBag)
        
        viewModel.notificationFrequency.subscribe(onNext: { [weak self] frequency in
            if let frequency = frequency {
                self?.setSelected(frequency: frequency)
            }
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.notificationFrequency)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
