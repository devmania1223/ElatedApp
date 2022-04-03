//
//  ProfileAboutViewController+Bindings.swift
//  Elated
//
//  Created by Marlon on 5/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension ProfileAboutViewController {

    func bindView() {
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.bio.bind(to: aboutMeInfoLabel.rx.text).disposed(by: disposeBag)
        viewModel.info.bind(to: infoLabel.rx.text).disposed(by: disposeBag)
        viewModel.nameAge.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.quickInfo.bind(to: quickFactsCollectionView.data).disposed(by: disposeBag)

    }
    
    func bindEvent() {
        
        viewModel.images.subscribe(onNext: { [weak self] args in
            self?.profileImageView.imageView.kf.setImage(with: URL(string: args.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        }).disposed(by: disposeBag)

    }
    
}
