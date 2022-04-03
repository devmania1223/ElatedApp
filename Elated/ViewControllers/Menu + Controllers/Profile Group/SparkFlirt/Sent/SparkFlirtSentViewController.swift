//
//  SparkFlirtSentViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtSentViewController: BaseViewController {
    
    let viewModel = SparkFlirtSentViewModel()

    let collectionView: SparkFlirtSentCollectionView = {
        let collectionView = SparkFlirtSentCollectionView()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TooltipManager.shared.reInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getSparkFlirtOutgoingInvites(1)
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
        
        viewModel.sparkFlirts.bind(to: collectionView.data).disposed(by: disposeBag)
        
        collectionView.didCancel.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.revokeInvitation(atIndex: index)
        }).disposed(by: disposeBag)
        
        collectionView.didNudge.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.sendSparkFlirtNudge(info: self.viewModel.sparkFlirts.value[index])
        }).disposed(by: disposeBag)
        
        collectionView.didSelectProfile.subscribe(onNext: { [weak self] index in
            guard let self = self,
                  let userId = self.viewModel.sparkFlirts.value[index].id
            else { return }
            
            let vc = ProfilePageViewController("profile.view.main".localized, viewUserID: userId)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.show(vc, sender: nil)
        }).disposed(by: disposeBag)
    }

}

