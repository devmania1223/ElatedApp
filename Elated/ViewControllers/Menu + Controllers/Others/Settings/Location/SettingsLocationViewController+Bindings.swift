//
//  SettingsLocationViewController+Bindings.swift
//  Elated
//
//  Created by Yiel Miranda on 3/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift

extension SettingsLocationViewController {
    
    func bindView() {
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)

        viewModel.address.bind(to: addressTextfield.rx.text).disposed(by: disposeBag)
        viewModel.zipCode.bind(to: zipCodeTextfield.rx.text).disposed(by: disposeBag)
        
        viewModel.allowSave.bind(to: saveButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.allowSave.bind(to: nextButton.rx.isEnabled).disposed(by: disposeBag)

        viewModel.places.bind(to: tableView.data).disposed(by: disposeBag)
    }

    func bindEvents() {
    
        addressTextfield.rx.controlEvent([.editingDidBegin, .editingChanged])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = false
                self.dismissPlacesButton.isHidden = false
                NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                       selector: #selector(self.triggerSearch),
                                                       object: self.addressTextfield)
                self.perform(#selector(self.triggerSearch),
                             with: self.addressTextfield,
                             afterDelay: 0.6)
        }).disposed(by: disposeBag)
        
        zipCodeTextfield.rx.controlEvent([.editingDidBegin, .editingChanged])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 100)) {
                    //delay
                    self.viewModel.zipCode.accept(self.zipCodeTextfield.text ?? "")
                }
        }).disposed(by: disposeBag)
        
        nearMeButton.rx.tap.map { .nearMe }.bind(to: viewModel.selectedLocation).disposed(by: disposeBag)
        otherButton.rx.tap.map { .other }.bind(to: viewModel.selectedLocation).disposed(by: disposeBag)
        
        dismissPlacesButton.rx.tap.map { true }.bind(to: tableView.rx.isHidden).disposed(by: disposeBag)
        dismissPlacesButton.rx.tap.map { true }.bind(to: dismissPlacesButton.rx.isHidden).disposed(by: disposeBag)
        dismissPlacesButton.rx.tap.bind { [weak self] in self?.addressTextfield.resignFirstResponder() }.disposed(by: disposeBag)
        
        viewModel.selectedLocation.subscribe(onNext: { [weak self] location in
            guard let self = self else { return }
            
            let selectedButton = location == .nearMe ? self.nearMeButton : self.otherButton
            let unSelectedButton = location == .nearMe ? self.otherButton : self.nearMeButton

            self.setButtonSelection(button: selectedButton, selected: true)
            self.setButtonSelection(button: unSelectedButton, selected: false)
            
            self.addressTextfield.isHidden = location == .nearMe
            self.zipCodeTextfield.isHidden = location == .nearMe
            self.tableView.isHidden = location == .nearMe
            self.dismissPlacesButton.isHidden = location == .nearMe

            if location == .nearMe {
                self.viewModel.selectedPlace.accept(nil)
            }
        }).disposed(by: disposeBag)
        
        tableView.didSelect.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            let place = self.viewModel.places.value[index]
            self.viewModel.selectedPlace.accept(place)
            self.tableView.isHidden = true
            self.dismissPlacesButton.isHidden = true
        }).disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            if type == .edit {
                self.title = "profile.editProfile.title".localized
            } else {
                self.title = "settings.edit.title".localized
            }
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.location)
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.location)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }
}
