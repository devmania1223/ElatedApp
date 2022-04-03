//
//  SparkFlirtInviteCollectionView.swift
//  Elated
//
//  Created by Marlon on 5/1/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SparkFlirtInviteCollectionView: UICollectionView {
    
    private let disposeBag = DisposeBag()
    
    //change with data models
    let data = BehaviorRelay<[SparkFlirtInfo]>(value: [])
    let didAccept = PublishRelay<Int>()
    let didDecline = PublishRelay<Int>()
    let didSelectProfile = PublishRelay<Int>()
    let didAddToFavorites = PublishRelay<Int>()

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height + 28)
    }
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 110, height: 110)
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 10
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.backgroundColor = .white
        self.register(SparkFlirtInviteCollectionViewCell.self,
                      forCellWithReuseIdentifier: SparkFlirtInviteCollectionViewCell.identifier)
        self.dataSource = self
        self.delegate = self
        
        bind()
    }
    
    private func bind() {
        data.subscribe(onNext: { [weak self] data in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SparkFlirtInviteCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (data.value.count == 0) {
            collectionView.setEmptyMessage("sparkFlirt.empty.invites".localized)
        } else {
            collectionView.restore()
        }
        
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SparkFlirtInviteCollectionViewCell.identifier,
                                                      for: indexPath) as? SparkFlirtInviteCollectionViewCell ?? SparkFlirtInviteCollectionViewCell()
        let user = data.value[indexPath.item].user
        cell.userData = user
        
        cell.didAccept = { [weak self] in
            self?.didAccept.accept(indexPath.row)
        }
        
        cell.didDecline = { [weak self] in
            self?.didDecline.accept(indexPath.row)
        }
        
        cell.didAddToFavorites = { [weak self] in
            self?.didAddToFavorites.accept(indexPath.row)
        }
        
        return cell
    }
}

extension SparkFlirtInviteCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2 - 8//spacing
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectProfile.accept(indexPath.row)
    }
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? SparkFlirtInviteCollectionViewCell else { return }
        
        if indexPath.row == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.prepareTooltips(collectionView: collectionView, cell: cell)
            }
        }
    }

}

//MARK: - Private Functions
extension SparkFlirtInviteCollectionView {
    
    private func prepareTooltips(collectionView: UICollectionView, cell: SparkFlirtInviteCollectionViewCell) {
        
        TooltipManager.shared.addTip(TooltipInfo(tipId: .sparkFlirtAcceptInvite,
                                                 direction: .down,
                                                 parentView: collectionView.superview ?? collectionView,
                                                 maxWidth: 100,
                                                 inView: cell,
                                                 fromRect: cell.sparkButton.frame,
                                                 offset: 0,
                                                 duration: 2.0))
        TooltipManager.shared.addTip(TooltipInfo(tipId: .sparkFlirtAddToFavorites,
                                                 direction: .down,
                                                 parentView: collectionView.superview ?? collectionView,
                                                 maxWidth: 100,
                                                 inView: cell,
                                                 fromRect: cell.starButton.frame,
                                                 offset: 0,
                                                 duration: 2.0))
        TooltipManager.shared.showIfNeeded()
    }
    
}
