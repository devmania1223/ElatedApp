//
//  CommonCollectionView.swift
//  Elated
//
//  Created by Marlon on 2021/3/12.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CommonCollectionView: UICollectionView {
    
    struct Theme {
        var borderColor: UIColor = .white
        var borderWidth: CGFloat = 0
        var backgroundColor: UIColor = .white
        var textColor: UIColor = .black
        
        init(borderColor: UIColor,
             borderWidth: CGFloat,
             backgroundColor: UIColor,
             textColor: UIColor) {
            
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.backgroundColor = backgroundColor
            self.textColor = textColor
        }
    }
    
    enum SelectionType {
        case single
        case multiple
        case none
    }
    
    private let disposeBag = DisposeBag()
    
    //change with data models
    let data = BehaviorRelay<[CommonDataModel]>(value: [])
    let isEdit = BehaviorRelay<Bool>(value: false)
    let selectedItems = BehaviorRelay<[Int]>(value: [])
    var theme: Theme? = nil
    var editImage: UIImage?
    var editButtonWidth: Double? = nil
    var didRemoveItem = PublishRelay<Int>()
    var didRemoveItemObject = PublishRelay<CommonDataModel>()

    private var selection: SelectionType = .none

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height + 28)
    }
    
    init(_ data: [CommonDataModel] = [],
         isEdit: Bool,
         selectionType: SelectionType = .none,
         scrollDirection: UICollectionView.ScrollDirection? = nil,
         theme: Theme? = nil) {
        
        
        
        if let direction = scrollDirection, direction == .horizontal {
            //for 1 line collection view
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = scrollDirection ?? .vertical
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.itemSize = CGSize(width: 100, height: 30)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            super.init(frame: CGRect(x: 0, y: 0, width: 32, height: 30), collectionViewLayout: flowLayout)
        } else {
            let flowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.itemSize = CGSize(width: 100, height: 30)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            super.init(frame: CGRect(x: 0, y: 0, width: 32, height: 30), collectionViewLayout: flowLayout)
        }
        
        
        self.backgroundColor = .white
        self.isScrollEnabled = false
        self.register(CommonCollectionViewCell.self,
                      forCellWithReuseIdentifier: CommonCollectionViewCell.identifier)
        self.isEdit.accept(isEdit)
        self.theme = theme
        self.dataSource = self
        self.delegate = self
        self.data.accept(data)
        self.selection = selectionType
        bind()
    }
    
    private func bind() {
        data.subscribe(onNext: { [weak self] _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
        
        didRemoveItem.subscribe(onNext: { [weak self] index in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommonCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCollectionViewCell.identifier,
                                                      for: indexPath) as? CommonCollectionViewCell ?? CommonCollectionViewCell()
        let value = data.value[indexPath.item]
        cell.theme = theme
        cell.setData(value.image,
                     text: value.title,
                     isEdit: isEdit.value,
                     selected: selectedItems.value.contains(indexPath.item),
                     backgroundColor: value.background)
        
        if let editImage = editImage {
            cell.editButton.setImage(editImage, for: .normal)
        }
        
        if let editWidth = editButtonWidth {
            cell.editButtonWidth = editWidth
        }
        
        cell.edit = { [unowned self] in
            var data = self.data.value
            self.didRemoveItem.accept(indexPath.item)
            self.didRemoveItemObject.accept(data[indexPath.item])
            data.remove(at: indexPath.item)
            self.data.accept(data)
        }
        
        return cell
    }
}

extension CommonCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selection == .multiple {
            var items = selectedItems.value
            if items.contains(indexPath.row) {
                items = items.filter { $0 != indexPath.row }
                selectedItems.accept(items)
            } else {
                items.append(indexPath.row)
                selectedItems.accept(items)
            }
            collectionView.reloadData()
        } else if selection == .single {
            selectedItems.accept([indexPath.row])
            collectionView.reloadData()
        }
    }
}
