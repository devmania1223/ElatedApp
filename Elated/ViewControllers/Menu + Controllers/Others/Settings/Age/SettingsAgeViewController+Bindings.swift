//
//  SettingsAgeViewController+Bindings.swift
//  Elated
//
//  Created by Yiel Miranda on 3/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift

extension SettingsAgeViewController {
    func bindView() {
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.minAge.subscribe( onNext: { [weak self] age in
            self?.minAgeLabel.text = "\(age)"
            self?.rangeSlider.lowerValue = Double(age)
        }).disposed(by: disposeBag)
        
        viewModel.maxAge.subscribe( onNext: { [weak self] age in
            self?.maxAgeLabel.text = "\(age)"
            self?.rangeSlider.upperValue = Double(age)
        }).disposed(by: disposeBag)
    }
    
    func bindEvents() {
        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.ageRange)
        }.disposed(by: disposeBag)
        
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(sender:)),
                              for: .valueChanged)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            if type == .onboarding {
                self.title = ""
                self.view.addSubview(self.bottomBackground)
                self.bottomBackground.snp.makeConstraints { make in
                    make.height.equalTo(135) //including offset 2
                    make.left.equalToSuperview().offset(-2)
                    make.right.bottom.equalToSuperview().offset(2)
                }
                
                self.view.addSubview(self.nextButton)
                self.nextButton.snp.makeConstraints { make in
                    make.centerY.equalTo(self.bottomBackground)
                    make.left.right.equalToSuperview().inset(33)
                    make.height.equalTo(50)
                }
            } else if type == .edit {
                self.title = "profile.editProfile.title".localized
            } else {
                self.title = "settings.edit.title".localized
            }
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.ageRange)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }
}
