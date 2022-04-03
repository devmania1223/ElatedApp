//
//  FavoritesMyCollectionView.swift
//  Elated
//
//  Created by Marlon on 5/4/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesMyCollectionView: UICollectionView {

    private let disposeBag = DisposeBag()
    
    var data = BehaviorRelay<[Match]>(value: [])
    var didDeleteFavorites = PublishRelay<Match>()
    var didSendSpark = PublishRelay<Match>()
    let didSelectProfile = PublishRelay<Match>()
    var getMoreFavorites = PublishRelay<Void>()
    
    private let spacing:CGFloat = 16
    
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
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: spacing, bottom: 10, right: spacing)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.backgroundColor = .white
        self.register(FavoritesMyCollectionViewCell.self,
                      forCellWithReuseIdentifier: FavoritesMyCollectionViewCell.identifier)
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

extension FavoritesMyCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesMyCollectionViewCell.identifier,
                                                      for: indexPath) as? FavoritesMyCollectionViewCell ?? FavoritesMyCollectionViewCell()
        let match = data.value[indexPath.item]
        cell.set(match)
        
        cell.cancelAction = { [weak self] in
            self?.didDeleteFavorites.accept(match)
        }
        
        cell.sparkAction = { [weak self] in
            self?.didSendSpark.accept(match)
        }
        
        return cell
    }
}

extension FavoritesMyCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = 3 * spacing // leading + space between 2 cells + trailing
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let match = data.value[indexPath.item]
        didSelectProfile.accept(match)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = (scrollView.contentSize.height - contentYoffset) * 0.75
        // Start fetching the next page once the scroll reached 75% of the screen for a more continous scrolling.
        if distanceFromBottom < height {
            getMoreFavorites.accept(())
        }
    }
}

