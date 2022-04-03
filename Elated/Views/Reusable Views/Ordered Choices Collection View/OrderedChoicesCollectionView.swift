//
//  OrderedChoicesCollectionView.swift
//  Elated
//
//  Created by Rey Felipe on 8/11/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


struct ToTAnswer {
    var text: String
    var id: Int
}

class OrderedChoicesCollectionView: UICollectionView {
    
    private let disposeBag = DisposeBag()
    
    public static let cellWidthHeight = 40
    
    //change with data models
    var selectionSize = BehaviorRelay<Int>(value: 3)
//    var data = BehaviorRelay<[ToTAnswer]>(value: [])
    var data = BehaviorRelay<[ThisOrThatOrderedChoicesPreference]>(value: [])
    private var selectedIndexItem = BehaviorRelay<Int>(value: 0)
    
    let didRemove = PublishRelay<Int>()
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: OrderedChoicesCollectionView.cellWidthHeight, height: OrderedChoicesCollectionView.cellWidthHeight)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.backgroundColor = .clear
        self.clipsToBounds = false
        self.dragInteractionEnabled = true
        self.dragDelegate = self
        self.dropDelegate = self
        self.isScrollEnabled = false
        self.register(OrderedChoicesCollectionViewCell.self,
                      forCellWithReuseIdentifier: OrderedChoicesCollectionViewCell.identifier)
        self.dataSource = self
        self.delegate = self
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        data.subscribe(onNext: { [weak self] data in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
        guard let item = coordinator.items.first,
              let sourceIndexPath = item.sourceIndexPath,
              self.data.value.count >= destinationIndexPath.row + 1 // avoid index out of bound
        else { return }
        
        collectionView.performBatchUpdates( { [weak self] in
            guard let self = self else { return }
            self.data.remove(at: sourceIndexPath.item)
            self.data.insert(item.dragItem.localObject as! ThisOrThatOrderedChoicesPreference, at: destinationIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
    
        }, completion: { [weak self] _ in
            
        })
    }
}

extension OrderedChoicesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionSize.value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderedChoicesCollectionViewCell.identifier,
                                                      for: indexPath) as? OrderedChoicesCollectionViewCell ?? OrderedChoicesCollectionViewCell()
        let index = indexPath.item
        if indexPath.item >= data.value.count {
            cell.setData(index + 1, value: nil)
        } else {
            let answer = data.value[index]
            cell.setData(index + 1, value: answer)
        }

        cell.didDelete = { [weak self] in
            // TODO: Add remove from order here, bubble option should popup on the screen
        }

        return cell
    }
}

extension OrderedChoicesCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthHeight = OrderedChoicesCollectionView.cellWidthHeight
        return CGSize(width: widthHeight, height: widthHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalCellWidth = OrderedChoicesCollectionView.cellWidthHeight * selectionSize.value
        let totalSpacingWidth = 10 * (selectionSize.value - 1)
        let collectionViewWidth = collectionView.bounds.width
        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item  < data.value.count else { return }
        didRemove.accept(indexPath.item)
    }
}

// MARK: UICollectionViewDragDelegate
extension OrderedChoicesCollectionView: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        // avoid index out of bound, trying to move the "add photo" cell
        guard self.data.value.count >= indexPath.row + 1 else { return [] }
        selectedIndexItem.accept(indexPath.row)
        let item = self.data.value[indexPath.row]
        let itemProvider = NSItemProvider(object: item.rawValue as NSString)
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
extension OrderedChoicesCollectionView: UICollectionViewDropDelegate {
    
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

// MARK: UIDropInteractionDelegate
extension OrderedChoicesCollectionView: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    // handle drop to UICollectionView's superview
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print("UIDropInteractionDelegate performDrop: \(session.location(in: superview!))")
        print("Selected Item: \(selectedIndexItem.value)")
        guard selectedIndexItem.value < data.value.count else { return }
        didRemove.accept(selectedIndexItem.value)
        selectedIndexItem.accept(0)
    }
}
