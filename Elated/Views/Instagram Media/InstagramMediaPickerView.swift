//
//  InstagramMediaPickerView.swift
//  Elated
//
//  Created by Marlon on 6/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InstagramMediaPickerView: UICollectionView {

    private let disposeBag = DisposeBag()
    
    //change with data models
    let data = BehaviorRelay<[InstagramMedia]>(value: [])
    let didSelect = PublishRelay<InstagramMedia>()

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
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.backgroundColor = .white
        self.register(GalleryCollectionViewCell.self,
                      forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
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

extension InstagramMediaPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier,
                                                      for: indexPath) as? GalleryCollectionViewCell ?? GalleryCollectionViewCell()
        cell.setData(data.value[indexPath.item].mediaURL, hideDeleteFrame: true, type: .view)
        return cell
    }
}

extension InstagramMediaPickerView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthHeight = collectionView.bounds.width/3.0 - 8//spacing
        return CGSize(width: widthHeight, height: widthHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect.accept(data.value[indexPath.item])
    }

}
