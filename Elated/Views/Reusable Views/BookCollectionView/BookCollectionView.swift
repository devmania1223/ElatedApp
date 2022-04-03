//
//  SideScrollCollectionView.swift
//  Elated
//
//  Created by Marlon on 2021/3/12.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookCollectionView: UICollectionView, UICollectionViewDelegate {
    
    let requiredHeight = 187
     
    private let disposeBag = DisposeBag()
    
    let data = BehaviorRelay<[Book]>(value: [])
    var shouldHideDeleteButton = true
    var didDelete = PublishRelay<Int>()
    var getMoreBooks = PublishRelay<Void>()

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height + 28)
    }
    
    init(shouldHideDeleteButton: Bool) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.itemSize = CGSize(width: 101, height: 173)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.backgroundColor = .white
        self.register(BookCollectionViewCell.self,
                      forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        self.delegate = self
        self.dataSource = self
        self.shouldHideDeleteButton = shouldHideDeleteButton
        
        bind()
    }
    
    private func bind() {
        data.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier,
                                                      for: indexPath) as? BookCollectionViewCell ?? BookCollectionViewCell()
        let rowData = data.value[indexPath.item]
        cell.setData(URL(string: rowData.cover ?? ""),
                     title: rowData.title ?? "",
                     author: rowData.authors.joined(separator: ", "),
                     buttonHide: shouldHideDeleteButton)
        
        cell.didDelete = { [weak self] in
            self?.didDelete.accept(indexPath.item)
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let contentXoffset = scrollView.contentOffset.x
        let distanceFromEnd = (scrollView.contentSize.width - contentXoffset) * 0.75
        // Start fetching books once the scroll reached 75% of the screen for a more continous scrolling.
        if distanceFromEnd < width {
            getMoreBooks.accept(())
        }
    }
    
}
