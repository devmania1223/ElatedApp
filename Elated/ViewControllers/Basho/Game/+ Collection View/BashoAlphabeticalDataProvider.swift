//
//  BashoAlphabeticalDataProvider.swift
//  Elated
//
//  Created by Marlon on 8/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import DragDropiOS
import SwiftyJSON
import DragDropiOS

class BashoAlphabeticalDataProvider: NSObject {
    
    var viewModel: BashoGameViewModel!
    var collectionView: DragDropCollectionView!
    
    init(_ collectionView: DragDropCollectionView, viewModel: BashoGameViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
    }
    
}

extension BashoAlphabeticalDataProvider: DragDropCollectionViewDelegate {
    
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
        let key = viewModel.alphabeticalSuggestionsArrayKeys.value[indexPath.section]
        let model = viewModel.alphabeticalSuggestions.value[key]![indexPath.row]
        viewModel.tipShowed.accept(true)
        return !model.word.isEmpty
    }
    
    func collectionView(_ collectionView: UICollectionView, dragInfoForIndexPath indexPath: IndexPath) -> AnyObject {
        
        let key = viewModel.alphabeticalSuggestionsArrayKeys.value[indexPath.section]
        let model = viewModel.alphabeticalSuggestions.value[key]![indexPath.row]
        var dragInfo = WordSuggestion(id: model.id ?? 0,
                                      word: model.word)
        dragInfo.itemIndex = indexPath.item
        viewModel.tipShowed.accept(true)
        return dragInfo as AnyObject
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        canDropWithDragInfo dataItem: AnyObject,
                        AtIndexPath indexPath: IndexPath) -> Bool {
        
        let key = viewModel.alphabeticalSuggestionsArrayKeys.value[indexPath.section]
        let model = viewModel.alphabeticalSuggestions.value[key]![indexPath.row]
        let dragInfo = dataItem as! WordSuggestion
        
        viewModel.tipShowed.accept(true)
        
        if !model.word.isEmpty {
            return false
        }
        
        clearCellsDrogStatusOfCollectionView()
        
        for _ in collectionView.visibleCells{
            if model.word.isEmpty {
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
        viewModel.tipShowed.accept(true)
        clearCellsDrogStatusOfCollectionView()
        collectionView.reloadData()
    }
    
    //MARK: Drop
    func collectionView(_ collectionView: UICollectionView, dropOutsideWithDragInfo info: AnyObject) {
        viewModel.tipShowed.accept(true)
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
        viewModel.tipShowed.accept(true)
        //viewModel.suggestions.value[dropIndexPath.item].word = (dragInfo as! WordSuggestion).word
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

extension BashoAlphabeticalDataProvider: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.alphabeticalSuggestionsArrayKeys.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let key = viewModel.alphabeticalSuggestionsArrayKeys.value[section]
        return viewModel.alphabeticalSuggestions.value[key]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let key = viewModel.alphabeticalSuggestionsArrayKeys.value[indexPath.section]
        let model = viewModel.alphabeticalSuggestions.value[key]![indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BashoSuggestionDragDropCollectionCell.identifier, for: indexPath)
            as? BashoSuggestionDragDropCollectionCell ?? BashoSuggestionDragDropCollectionCell()
        
        cell.updateData(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let key = viewModel.alphabeticalSuggestionsArrayKeys.value[indexPath.section]
        let model = viewModel.alphabeticalSuggestions.value[key]![indexPath.row]
        viewModel.tipShowed.accept(true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: BashoAlphabeticalCollectionHeader.identifier,
                                                                     for: indexPath) as? BashoAlphabeticalCollectionHeader ?? BashoAlphabeticalCollectionHeader()
        
        let key = viewModel.alphabeticalSuggestionsArrayKeys.value[indexPath.section]
        header.label.text = key
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
}
