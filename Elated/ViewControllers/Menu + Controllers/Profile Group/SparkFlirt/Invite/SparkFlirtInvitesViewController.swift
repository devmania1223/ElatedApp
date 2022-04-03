//
//  SparkFlirtInvitesViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtInvitesViewController: BaseViewController {
    
    let viewModel = SparkFlirtInvitesViewModel()
    let favoritesViewModel = FavoritesViewModel()
    
    let collectionView: SparkFlirtInviteCollectionView = {
        let collectionView = SparkFlirtInviteCollectionView()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.getSparkFlirtInvites(1)
        TooltipManager.shared.reInit()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.invites.bind(to: collectionView.data).disposed(by: disposeBag)
        
        viewModel.success.subscribe( onNext: { [weak self] inviteResponse in
            guard let self = self else { return }

            let index = self.viewModel.selectedIndex.value

            guard let inviteId = self.viewModel.invites.value[index].id,
                  let user = self.viewModel.invites.value[index].user
            else { return }
            
            switch inviteResponse {
            case .accept:
                self.viewModel.invites.remove(at: index)
                let vc = GameOptionsViewController(inviteId, playWith: user)
                self.show(vc, sender: nil)
            case .decline:
                self.viewModel.invites.remove(at: index)
            }
        }).disposed(by: disposeBag)
        
        collectionView.didAccept.subscribe(onNext: { [weak self] index in
            guard let self = self,
                  let inviteId = self.viewModel.invites.value[index].id
            else { return }
            self.viewModel.selectedIndex.accept(index)
            self.viewModel.acceptDeclineInvitation(inviteId, accept: true)
        }).disposed(by: disposeBag)
        
        collectionView.didDecline.subscribe(onNext: { [weak self] index in
            guard let self = self,
                  let inviteId = self.viewModel.invites.value[index].id
            else { return }
            self.viewModel.selectedIndex.accept(index)
            self.viewModel.acceptDeclineInvitation(inviteId, accept: false)
        }).disposed(by: disposeBag)
        
        collectionView.didSelectProfile.subscribe(onNext: { [weak self] index in
            guard let self = self,
                  let userId = self.viewModel.invites.value[index].user?.userId
            else { return }
            
            let vc = ProfilePageViewController("profile.view.main".localized, viewUserID: userId)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.show(vc, sender: nil)
        }).disposed(by: disposeBag)
        
        collectionView.didAddToFavorites.subscribe(onNext: { [weak self] index in
            guard let self = self,
                  let userId = self.viewModel.invites.value[index].user?.userId
            else { return }
            self.favoritesViewModel.setFavorite(userId)
        }).disposed(by: disposeBag)
    }
    
}

