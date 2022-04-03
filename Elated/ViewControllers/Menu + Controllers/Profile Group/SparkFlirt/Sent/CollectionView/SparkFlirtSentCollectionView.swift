//
//  SparkFlirtSentCollectionView.swift
//  Elated
//
//  Created by Marlon on 5/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SparkFlirtSentCollectionView: UICollectionView {

    private let disposeBag = DisposeBag()
    
    var data = BehaviorRelay<[SparkFlirtInfo]>(value: [])
    let didCancel = PublishRelay<Int>()
    let didNudge = PublishRelay<Int>()
    let didSelectProfile = PublishRelay<Int>()

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
        self.register(SparkFlirtSentCollectionViewCell.self,
                      forCellWithReuseIdentifier: SparkFlirtSentCollectionViewCell.identifier)
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

extension SparkFlirtSentCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        data.value.count == 0 ? collectionView.setEmptyMessage("sparkFlirt.empty.sent".localized)
            : collectionView.restore()
        
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SparkFlirtSentCollectionViewCell.identifier,
                                                      for: indexPath) as? SparkFlirtSentCollectionViewCell ?? SparkFlirtSentCollectionViewCell()
        let userData = data.value[indexPath.item].user
        cell.setup(userData)
        
        cell.didCancel = { [weak self] in
            self?.didCancel.accept(indexPath.row)
        }
        cell.didNudge = { [weak self] in
            self?.didNudge.accept(indexPath.row)
        }
        return cell
    }
}

extension SparkFlirtSentCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
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
        guard let cell = cell as? SparkFlirtSentCollectionViewCell else { return }
        
        if indexPath.row == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.prepareTooltips(collectionView: collectionView, cell: cell)
            }
        }
    }
    
}

//MARK: - Private Functions
extension SparkFlirtSentCollectionView {
    
    private func prepareTooltips(collectionView: UICollectionView, cell: SparkFlirtSentCollectionViewCell) {
        
        let parentView = collectionView.superview ?? collectionView
        cell.layer.zPosition = 1
        
        TooltipManager.shared.addTip(TooltipInfo(tipId: .sparkFlirtCancelInvite,
                                                 direction: .auto,
                                                 parentView: parentView,
                                                 maxWidth: 100,
                                                 inView: cell.stackview,
                                                 fromRect: cell.cancelButton.frame,
                                                 offset: 0,
                                                 duration: 2.0))
        TooltipManager.shared.addTip(TooltipInfo(tipId: .sparkFlirtSendNudge,
                                                 direction: .auto,
                                                 parentView: parentView,
                                                 maxWidth: 100,
                                                 inView: cell.stackview,
                                                 fromRect: cell.nudgeButton.frame,
                                                 offset: 0,
                                                 duration: 2.0))
        TooltipManager.shared.showIfNeeded()
    }
    
}

