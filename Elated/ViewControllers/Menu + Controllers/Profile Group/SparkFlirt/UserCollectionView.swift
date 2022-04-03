//
//  UserCollectionView.swift
//  Elated
//
//  Created by Marlon on 10/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserCollectionView: UICollectionView {
    
    private let disposeBag = DisposeBag()
    
    //change with data models
    let data = BehaviorRelay<[UserInfoShort]>(value: [])
    let userStatus = BehaviorRelay<[String: Bool]?>(value: nil)
    let isEdit = BehaviorRelay<Bool>(value: false)
    let didSelect = PublishRelay<Int>()

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
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.itemSize = CGSize(width: 100, height: 30)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        super.init(frame: CGRect(x: 0, y: 0, width: 32, height: 30), collectionViewLayout: flowLayout)
        
        self.backgroundColor = .white
        self.isScrollEnabled = false
        self.register(UserCollectionViewCell.self,
                      forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        self.dataSource = self
        self.delegate = self
        bind()
    }
    
    private func bind() {
        Observable.combineLatest(data, userStatus)
            .subscribe(onNext: { [weak self] _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier,
                                                      for: indexPath) as? UserCollectionViewCell ?? UserCollectionViewCell()
        let value = data.value[indexPath.item]
        let userStatus = self.userStatus.value
        var online = false
        
        if let user = userStatus,
           let id = value.id,
           let status = user["\(id)"] {
                online = status
        }
        
        cell.set(name: value.getDisplayName(),
                 avatar: URL(string: value.avatar?.image ?? ""),
                 online: online)
        return cell
    }
}

extension UserCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect.accept(indexPath.item)
    }
}

