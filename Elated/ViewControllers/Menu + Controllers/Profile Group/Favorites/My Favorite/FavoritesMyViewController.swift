//
//  FavoritesViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class FavoritesMyViewController: BaseViewController {

    let accountsViewModel = SparkFlirtSettingsBalanceViewModel()
    let viewModel = FavoritesMyViewModel()
    
    let collectionView = FavoritesMyCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.getFavorites(initialPage: true)
        accountsViewModel.getSparkFlirtAvailableCredit()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()

        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.favorites.bind(to: collectionView.data).disposed(by: disposeBag)

        collectionView.didSendSpark
            .subscribe( onNext: { [weak self] match in
                guard let self = self else { return }
                
                if self.accountsViewModel.availableCredits.value == 0 {
                    let vc = SparkFlirtStatusViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.show(vc, sender: nil)
                    return
                }
                
                let vc = SparkFlirtSendInviteViewController(userInfo: match)
                self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        collectionView.didDeleteFavorites.subscribe( onNext: { [weak self] match in
            guard let userId = match.matchedWith?.userId else {
                return
            }
            self?.viewModel.deleteFavorite(userId)
        }).disposed(by: disposeBag)
        
        collectionView.didSelectProfile.subscribe(onNext: { [weak self] match in
            guard let userId = match.matchedWith?.userId else {
                return
            }
            
            let vc = ProfilePageViewController("profile.view.main".localized, viewUserID: userId)
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.show(vc, sender: nil)
        }).disposed(by: disposeBag)
        
        collectionView.getMoreFavorites.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.getFavorites(initialPage: false)
        }).disposed(by: disposeBag)
        
    }

}
