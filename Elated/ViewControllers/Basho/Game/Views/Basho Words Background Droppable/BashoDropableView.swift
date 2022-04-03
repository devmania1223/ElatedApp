//
//  BashoDropableView.swift
//  Elated
//
//  Created by Marlon on 8/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import DragDropiOS
import UIKit

class BashoDropableView: UIView {
    
    var viewModel: AnyObject!
    
    // MARK : Status
    func moveOverStatus(){
        backgroundColor = UIColor.elatedPrimaryPurple.withAlphaComponent(0.5)
    }
    
    func normalStatus(){
        backgroundColor = UIColor.palePurplePantone
    }
    
    init(viewModel: AnyObject) {
        super.init(frame: .zero)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BashoDropableView: Droppable {
    
    func canDropWithDragInfo(_ dragInfo: AnyObject,  inRect rect: CGRect) -> Bool {
        if let _ = self.viewModel as? BashoGameViewModel,
           let _ = dragInfo as? WordSuggestion {
            moveOverStatus()
            return true
        }
        return false
    }
    
    func dropOverInfoInRect(_ rect: CGRect) -> AnyObject? {
        return nil
    }
    
    func dropOutside(_ dragInfo: AnyObject, inRect rect: CGRect) {
        normalStatus()
    }
    
    func dropComplete(_ dragInfo : AnyObject, dropInfo: AnyObject?, atRect rect: CGRect) -> Void{
        if let viewModel = self.viewModel as? BashoGameViewModel,
           let info = dragInfo as? WordSuggestion {
            normalStatus()
            
            var data = viewModel.bashoWords.value
            if !data.contains(where: { $0.word == info.word }) {
                data.append(info)
                viewModel.bashoWords.accept(data)
                viewModel.didAddBasho.accept(info)
            } else {
                viewModel.forceRefreshDragDropViews.accept(())
            }
            
        }
    }
    
    func stopDropping() {
        normalStatus()
    }

}
