//
//  SettingsViewController+Bindings.swift
//  Elated
//
//  Created by Yiel Miranda on 4/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift

extension SettingsViewController {
    func bindView() {
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.user,
                                 viewModel.notifEmail,
                                 viewModel.notifMatch,
                                 viewModel.notifSparkFlirtInvite,
                                 viewModel.notifNudge,
                                 viewModel.notifFavorite)
            .subscribe(onNext: { [weak self] _, notifEmail, _, _, notifNudge, _ in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    func bindEvents() {
        menuButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.present(self.menu, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        viewModel.gender.subscribe(onNext: { [weak self] gender in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }).disposed(by: disposeBag)
        
        viewModel.minAge.subscribe(onNext: { [weak self] age in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }).disposed(by: disposeBag)
        
        viewModel.distance.subscribe(onNext: { [weak self] distance in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }).disposed(by: disposeBag)
        
        viewModel.selectedLocation.subscribe(onNext: { [weak self] location in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
        }).disposed(by: disposeBag)
    }
}
