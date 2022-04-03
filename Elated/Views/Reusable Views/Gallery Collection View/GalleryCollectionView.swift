//
//  GalleryCollectionView.swift
//  Elated
//
//  Created by Marlon on 2021/3/19.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryCollectionView: UICollectionView {
    
    internal let viewModel = EditProfileViewModel()

    enum CollectionType {
        case pureView
        case view
        case edit
    }
    
    private let disposeBag = DisposeBag()
    
    //change with data models
    var data = BehaviorRelay<[ProfileImage]>(value: [])
    let type = BehaviorRelay<CollectionType>(value: .view)
    let addPhoto = PublishRelay<Void>()
    let didSelect = PublishRelay<Int>()
    let didDelete = PublishRelay<Int>()

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height + 28)
    }
    
    init(_ type: CollectionType) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 110, height: 110)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.backgroundColor = .clear
        self.clipsToBounds = false
        self.dragInteractionEnabled = true
        self.dragDelegate = self
        self.dropDelegate = self
        self.isScrollEnabled = false
        self.register(GalleryCollectionViewCell.self,
                      forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        self.type.accept(type)
        self.dataSource = self
        self.delegate = self
        
        bind()
    }
    
    private func bind() {
        data.subscribe(onNext: { [weak self] data in
            self?.reloadData()
        }).disposed(by: disposeBag)
        
        type.subscribe(onNext: { [weak self] data in
            self?.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
        guard let item = coordinator.items.first,
              let sourceIndexPath = item.sourceIndexPath,
              self.data.value.count >= destinationIndexPath.row + 1 // avoid index out of bound
        else { return }
        
        collectionView.performBatchUpdates( { [weak self] in
            guard let self = self else { return }
            self.data.remove(at: sourceIndexPath.item)
            self.data.insert(item.dragItem.localObject as! ProfileImage, at: destinationIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
    
        }, completion: { [weak self] _ in
            
            guard let self = self,
                  let profileImage = item.dragItem.localObject as? ProfileImage,
                  let imageId = profileImage.pk
            else { return }
            
            let newPosition = destinationIndexPath.row + 1
            self.viewModel.swapImagePositions(imageId: imageId, newPosition: newPosition)
        })
    }
}

extension GalleryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //extra cell for adding a new photo
        return data.value.count + (type.value == .pureView ? 0 : 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier,
                                                      for: indexPath) as? GalleryCollectionViewCell ?? GalleryCollectionViewCell()
        
        let image = indexPath.row == data.value.count ? nil : URL(string: data.value[indexPath.item].image ?? "")
        
        cell.setData(image,
                     hideDeleteFrame: indexPath.row == data.value.count,
                     type: type.value)
        
        cell.didDelete = { [weak self] in
            self?.didDelete.accept(indexPath.row)
        }
        
        return cell
    }
}

extension GalleryCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthHeight = collectionView.bounds.width/3.0 - 8//spacing
        return CGSize(width: widthHeight, height: widthHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == data.value.count && type.value != .pureView {
            addPhoto.accept(())
        } else {
            didSelect.accept(indexPath.item)
        }
    }
}


// MARK: UICollectionViewDragDelegate
extension GalleryCollectionView: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        // avoid index out of bound, trying to move the "add photo" cell
        guard self.data.value.count >= indexPath.row + 1 else { return [] }
        
        let item = self.data.value[indexPath.row]
        
        guard let itemID = item.image else { return [] }
        
        let itemProvider = NSItemProvider(object: itemID as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        let parameters = UIDragPreviewParameters()
        let path = UIBezierPath(roundedRect: cell.contentView.frame, cornerRadius: cell.contentView.frame.width / 2)
        parameters.visiblePath = path
        parameters.backgroundColor = .clear
        
        return parameters
    }
}

// MARK: UICollectionViewDropDelegate
extension GalleryCollectionView: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator,
                              destinationIndexPath: destinationIndexPath,
                              collectionView: collectionView)
        }
    }
}
