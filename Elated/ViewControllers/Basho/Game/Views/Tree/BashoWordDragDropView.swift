//
//  WordDropDownVoew.swift
//  Elated
//
//  Created by Marlon on 8/4/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import DragDropiOS

class BashoWordDragDropView: UIView, Draggable {

    var word: WordSuggestion?

    var selected: Bool = false {
        didSet {
            if selected {
                selectedStatus()
            } else {
                normalStatus()
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    // MARK : Status
    func normalStatus(){
        backgroundColor = UIColor.white
    }
    
    func selectedStatus(){
        backgroundColor = UIColor.palePurplePantone.withAlphaComponent(0.5)
    }
    
    // MARK : Draggable
    func touchBeginAtPoint(_ point : CGPoint) -> Void {
        if selected {
            selectedStatus()
        }else{
            normalStatus()
        }
    }
    
    func canDragAtPoint(_ point: CGPoint) -> Bool {
        return !selected
    }
    
    func representationImageAtPoint(_ point: CGPoint) -> UIView? {
        var imageView : UIView?
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
                    
        imageView = UIImageView(image: img)
        imageView?.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)
        
        return imageView
    }
    
    func dragInfoAtPoint(_ point: CGPoint) -> AnyObject? {
        return word as AnyObject
    }
    
    func dragComplete(_ dragInfo: AnyObject, dropInfo: AnyObject?) {
        label.alpha = 0
        selected = true
        alpha = 0.8
    }
    
}
