//
//  BashoTreeItem.swift
//  Elated
//
//  Created by Marlon on 8/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class BashoTreeItem: UIView {

    @IBOutlet weak var word1View: BashoWordDragDropView! {
        didSet {
            word1View.cornerRadius = 12.5
            word1View.borderWidth = 2
            word1View.borderColor = .white
            word1View.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        }
    }
    
    @IBOutlet weak var word2View: BashoWordDragDropView! {
        didSet {
            word2View.cornerRadius = 12.5
            word2View.borderWidth = 2
            word2View.borderColor = .white
            word2View.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    func bind() {
        //UITapGestureRecognizer(target: self, action: #selector(wordTap))
    }
    
    func set(word1: WordSuggestion?,
             selectedWord1: Bool,
             word2: WordSuggestion?,
             selectedWord2: Bool) {
        word1View.label.text = word1?.word ?? ""
        word2View.label.text = word2?.word ?? ""
        word1View.label.alpha = selectedWord1 ? 0 : 1
        word2View.label.alpha = selectedWord2 ? 0 : 1
        word1View.word = word1
        word1View.selected = selectedWord1
        word2View.word = word2
        word2View.selected = selectedWord2
    }
    
    func wordTap(word: BashoWordDragDropView) {
        
    }


}
