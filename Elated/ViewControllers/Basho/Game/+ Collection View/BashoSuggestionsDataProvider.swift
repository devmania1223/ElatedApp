//
//  BashoGameViewController+CollectionView.swift
//  Elated
//
//  Created by Marlon on 8/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import DragDropiOS
import SwiftyJSON
import DragDropiOS

class BashoSuggestionsDataProvider: NSObject {
    
    var viewModel: BashoGameViewModel!
    var collectionView: DragDropCollectionView!
    
    init(_ collectionView: DragDropCollectionView, viewModel: BashoGameViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
    }
    
}

extension BashoSuggestionsDataProvider: DragDropCollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        touchBeginAtIndexPath indexPath: IndexPath) {
        clearCellsDrogStatusOfCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        representationImageAtIndexPath indexPath: IndexPath) -> UIImage? {
        
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            cell.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img
        }
        
        return nil
        
    }
    
    //MARK: Drag
    func collectionView(_ collectionView: UICollectionView,
                        canDragAtIndexPath indexPath: IndexPath) -> Bool {
        return !viewModel.suggestions.value[indexPath.item].word.isEmpty
    }
    
    func collectionView(_ collectionView: UICollectionView, dragInfoForIndexPath indexPath: IndexPath) -> AnyObject {
        var dragInfo = WordSuggestion(id: viewModel.suggestions.value[indexPath.item].id ?? 0,
                                      word: viewModel.suggestions.value[indexPath.item].word)
        dragInfo.itemIndex = indexPath.item
        dragInfo.word = viewModel.suggestions.value[indexPath.item].word
        dragInfo.id = viewModel.suggestions.value[indexPath.item].id
        return dragInfo as AnyObject
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        canDropWithDragInfo dataItem: AnyObject,
                        AtIndexPath indexPath: IndexPath) -> Bool {
        let dragInfo = dataItem as! WordSuggestion
        let overInfo = viewModel.suggestions.value[indexPath.item]
        
        viewModel.tipShowed.accept(true)
        
        //drag source is mouse over item（self）
        if !overInfo.word.isEmpty {
            return false
        }
        
        clearCellsDrogStatusOfCollectionView()
        
        for _ in collectionView.visibleCells{
            if overInfo.word.isEmpty {
                let cell = collectionView.cellForItem(at: indexPath) as! BashoSuggestionDragDropCollectionCell
                cell.moveOverStatus()
                debugPrint("can drop in . index = \(indexPath.item)")
                return true
            }else{
                debugPrint("can't drop in. index = \(indexPath.item)")
            }
        }
        
        return false
        
    }
    
    func collectionViewStopDragging(_ collectionView: UICollectionView) {
        clearCellsDrogStatusOfCollectionView()
        collectionView.reloadData()
    }
    
    //MARK: Drop
    func collectionView(_ collectionView: UICollectionView, dropOutsideWithDragInfo info: AnyObject) {
        clearCellsDrogStatusOfCollectionView()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dragCompleteWithDragInfo dragInfo: AnyObject,
                        atDragIndexPath dragIndexPath: IndexPath,
                        withDropInfo dropInfo: AnyObject?) -> Void{
        if (dropInfo != nil){
            //viewModel.suggestions.value[dragIndexPath.item].word = (dropInfo as! WordSuggestion).word
        }else{
            //viewModel.suggestions.value[dragIndexPath.item].fruit = nil
        }
        viewModel.tipShowed.accept(true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dropCompleteWithDragInfo dragInfo: AnyObject,
                        atDragIndexPath dragIndexPath: IndexPath?,
                        withDropInfo dropInfo: AnyObject?,
                        atDropIndexPath dropIndexPath: IndexPath) -> Void {
        //viewModel.suggestions.value[dropIndexPath.item].word = (dragInfo as! WordSuggestion).word
        viewModel.tipShowed.accept(true)
    }
    
    func collectionViewStopDropping(_ collectionView: UICollectionView) {
        clearCellsDrogStatusOfCollectionView()
        collectionView.reloadData()
    }
    
    func clearCellsDrogStatusOfCollectionView(){
        for cell in collectionView.visibleCells {
            if (cell as! BashoSuggestionDragDropCollectionCell).hasContent() {
                (cell as! BashoSuggestionDragDropCollectionCell).selectedStatus()
                continue
            }
            (cell as! BashoSuggestionDragDropCollectionCell).normalStatus()
        }
    }
}

extension BashoSuggestionsDataProvider: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.suggestions.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.suggestions.value[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BashoSuggestionDragDropCollectionCell.identifier, for: indexPath)
            as? BashoSuggestionDragDropCollectionCell ?? BashoSuggestionDragDropCollectionCell()
        
        cell.updateData(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.suggestions.value[indexPath.item]
        viewModel.selectedSuggestionItem.accept(model)
        viewModel.tipShowed.accept(true)
    }
    
}
